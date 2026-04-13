package com.mycompany.opd.resources;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import java.time.LocalDate;
import java.time.Month;
import java.time.temporal.TemporalAdjusters;
import java.util.Map;
import java.util.HashMap;

public class ScheduleValidator {

    /**
     * Checks if a given date is a weekend or a holiday.
     * @param date The date to check.
     * @param conn The database connection.
     * @return A string describing the reason the date is unavailable (e.g., "a weekend", "a holiday (New Year's Day)"), or null if the date is available.
     * @throws SQLException if a database access error occurs.
     */
    public static String getUnavailableReason(Date date, Connection conn) throws SQLException {
        // 1. Check if the date is a weekend
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
        if (dayOfWeek == Calendar.SATURDAY || dayOfWeek == Calendar.SUNDAY) {
            return "a weekend";
        }

        // 2. Check if the date is a calculated holiday
        LocalDate localDate = date.toLocalDate();
        String holidayName = getPhilippineHolidays(localDate.getYear()).get(localDate);
        if (holidayName != null) {
            return "a holiday (" + holidayName + ")";
        }
        
        return null; // Date is available
    }

    /**
     * Calculates Philippine holidays for a given year.
     * @param year The year to calculate holidays for.
     * @return A Map where the key is the holiday date and the value is the holiday name.
     */
    public static Map<LocalDate, String> getPhilippineHolidays(int year) {
        Map<LocalDate, String> holidays = new HashMap<>();

        // --- REGULAR HOLIDAYS ---

        // Fixed Holidays
        holidays.put(LocalDate.of(year, Month.JANUARY, 1), "New Year's Day");
        holidays.put(LocalDate.of(year, Month.APRIL, 9), "Araw ng Kagitingan");
        holidays.put(LocalDate.of(year, Month.MAY, 1), "Labor Day");
        holidays.put(LocalDate.of(year, Month.JUNE, 12), "Independence Day");
        holidays.put(LocalDate.of(year, Month.NOVEMBER, 30), "Bonifacio Day");
        holidays.put(LocalDate.of(year, Month.DECEMBER, 25), "Christmas Day");
        holidays.put(LocalDate.of(year, Month.DECEMBER, 30), "Rizal Day");

        // Movable Holidays (based on Easter)
        LocalDate easterSunday = calculateEasterSunday(year);
        holidays.put(easterSunday.minusDays(2), "Good Friday");
        holidays.put(easterSunday.minusDays(3), "Maundy Thursday");

        // National Heroes Day (Last Monday of August)
        LocalDate lastDayOfAugust = LocalDate.of(year, Month.AUGUST, 31);
        LocalDate nationalHeroesDay = lastDayOfAugust.with(TemporalAdjusters.lastInMonth(java.time.DayOfWeek.MONDAY));
        holidays.put(nationalHeroesDay, "National Heroes Day");


        // --- SPECIAL NON-WORKING DAYS ---

        holidays.put(LocalDate.of(year, Month.FEBRUARY, 25), "EDSA People Power Revolution Anniversary");
        holidays.put(LocalDate.of(year, Month.AUGUST, 21), "Ninoy Aquino Day");
        holidays.put(LocalDate.of(year, Month.NOVEMBER, 1), "All Saints' Day");
        holidays.put(LocalDate.of(year, Month.NOVEMBER, 2), "All Souls' Day");
        holidays.put(LocalDate.of(year, Month.DECEMBER, 8), "Feast of the Immaculate Conception of Mary");
        holidays.put(LocalDate.of(year, Month.DECEMBER, 31), "Last Day of the Year");

        // Black Saturday (day after Good Friday)
        holidays.put(easterSunday.minusDays(1), "Black Saturday");

        // Note: Chinese New Year is also a movable holiday but requires a more complex lunar calendar calculation.
        // It is omitted here for simplicity but can be added if needed.

        return holidays;
    }

    /**
     * Calculates the date of Easter Sunday for a given year using the Meeus/Jones/Butcher algorithm.
     * @param year The year to calculate for.
     * @return The date of Easter Sunday.
     */
    private static LocalDate calculateEasterSunday(int year) {
        int a = year % 19;
        int b = year / 100;
        int c = year % 100;
        int d = b / 4;
        int e = b % 4;
        int f = (b + 8) / 25;
        int g = (b - f + 1) / 3;
        int h = (19 * a + b - d - g + 15) % 30;
        int i = c / 4;
        int k = c % 4;
        int l = (32 + 2 * e + 2 * i - h - k) % 7;
        int m = (a + 11 * h + 22 * l) / 451;
        
        int month = (h + l - 7 * m + 114) / 31;
        int day = ((h + l - 7 * m + 114) % 31) + 1;

        return LocalDate.of(year, month, day);
    }
}