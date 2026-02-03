function certcheck --description "Check SSL certificate for a domain"
    set -l host $argv[1]
    set -l port 443

    if test -z "$host"
        echo "Usage: certcheck <host> [port]" >&2
        return 1
    end

    if test -n "$argv[2]"
        set port $argv[2]
    end

    # Wrap IPv6 addresses in brackets
    if string match -q '*:*' -- $host; and not string match -q '\[*' -- $host
        set host "[$host]"
    end

    set -l response (echo -n | timeout 5 openssl s_client -connect "$host:$port" -servername (string trim -c '[]' $host) 2>&1)
    set -l status_code $status

    if test $status_code -eq 124
        echo "Connection timed out: $host:$port" >&2
        return 1
    end

    set -l cert (printf '%s\n' $response | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p')

    if test -z "$cert"
        echo "Failed to connect to $host:$port" >&2
        return 1
    end

    printf '%s\n' $cert | openssl x509 -text | grep -E "DNS|Subject: CN"
end
