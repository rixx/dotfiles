#!/usr/bin/env python
import sys
import datetime

weekdays = [
    "Montag",
    "Dienstag",
    "Mittwoch",
    "Donnerstag",
    "Freitag",
    "Sonnabend",
    "Sonntag",
]


def load_template(name):
    with open(f"/home/rixx/.config/dotfiles/vim/templates/{name}") as f:
        return f.read()


def generate_year_file(year):
    print(
        load_template("journal-year.md").format(
            year=year,
            last_year=int(year) - 1,
            next_year=int(year) + 1,
        )
    )


def generate_month_file(month):
    year, month = month.split("-")
    next_month = int(month) + 1 if int(month) < 12 else 1
    next_month_year = int(year) + 1 if int(month) == 12 else year
    next_month_path = f"{year}-{next_month:02}"
    prev_month = int(month) - 1 if int(month) > 1 else 12
    prev_month_year = int(year) - 1 if int(month) == 1 else year
    prev_month_path = f"{year}-{prev_month:02}"

    day = datetime.date(int(year), int(month), 1)
    weeks = []
    while day.month == int(month):
        if day.weekday() == 0:
            week_end = (day + datetime.timedelta(days=6)).strftime("%d.%m.")
            # we need the calendar week here
            week_number = day.strftime("%W")
            weeks.append(
                f"[KW {week_number}: {day.day} - {week_end}](/journal/{year}-w{week_number})"
            )
        day += datetime.timedelta(days=1)

    week_string = "\n".join(weeks)
    print(
        load_template("journal-month.md").format(
            year=year,
            month=month,
            prev_month_path=prev_month_path,
            next_month_path=next_month_path,
            week_string=week_string,
        )
    )


def generate_week_file(day):
    year, week = day.split("-w")
    monday = datetime.datetime.strptime(f"{year}-W{week}-1", "%Y-W%W-%w")
    next_week = (monday + datetime.timedelta(days=7)).strftime("%Y-w%W")
    prev_week = (monday - datetime.timedelta(days=7)).strftime("%Y-w%W")
    month = monday.strftime("%m")

    days = []
    for i, tag in enumerate(weekdays):
        day = monday + datetime.timedelta(days=i)
        days.append(f"[{tag}](/journal/{day.strftime('%Y-%m-%d')})")

    print(
        load_template("journal-week.md").format(
            year=year,
            week=week,
            month=month,
            prev_week=prev_week,
            next_week=next_week,
            days="\n".join(days),
        )
    )


def generate_day_file(day):
    year, month, day = day.split("-")
    day = datetime.date(int(year), int(month), int(day))
    week = day.strftime("%W")
    day_str = f"{weekdays[day.weekday()]}, {day.strftime('%d.%m.%Y')}"
    print(
        load_template("journal-day.md").format(
            year=year,
            month=month,
            day=day,
            day_str=day_str,
            week=week,
        )
    )


def main():
    date_or_filename = sys.argv[1]
    if "." in date_or_filename:
        date = date_or_filename.rsplit(".", maxsplit=1)[0]
    else:
        date = date_or_filename

    # Options are: a year file (YYYY), a month file (YYYY-MM), a day file (YYYY-MM-DD), or a week file (YYYY-w##)
    if len(date) == 4:
        generate_year_file(date)
    elif len(date) == 7:
        generate_month_file(date)
    elif len(date) == 10:
        generate_day_file(date)
    elif len(date) == 8:
        generate_week_file(date)


if __name__ == "__main__":
    main()
