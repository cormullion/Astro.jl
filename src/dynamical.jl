export
    deltaT_seconds, 
    dt_to_ut, 
    tdt_to_bdt

#=

Functions which calculate the deltaT correction to convert between
dynamical and universal time.

Reference: Jean Meeus, _Astronomical Algorithms_, second edition, 1998

=#

# deltat_table is a list of tuples (jd, seconds), giving deltaT values
# for the beginnings of years in a historical range. [Meeus-1998: table 10.A]

deltat_table = {
    [cal_to_jd(1620, 1, 1), 121.0],
    [cal_to_jd(1622, 1, 1), 112.0],
    [cal_to_jd(1624, 1, 1), 103.0],
    [cal_to_jd(1626, 1, 1), 95.0],
    [cal_to_jd(1628, 1, 1), 88.0],
    
    [cal_to_jd(1630, 1, 1), 82.0],
    [cal_to_jd(1632, 1, 1), 77.0],
    [cal_to_jd(1634, 1, 1), 72.0],
    [cal_to_jd(1636, 1, 1), 68.0],
    [cal_to_jd(1638, 1, 1), 63.0],
    
    [cal_to_jd(1640, 1, 1), 60.0],
    [cal_to_jd(1642, 1, 1), 56.0],
    [cal_to_jd(1644, 1, 1), 53.0],
    [cal_to_jd(1646, 1, 1), 51.0],
    [cal_to_jd(1648, 1, 1), 48.0],
    
    [cal_to_jd(1650, 1, 1), 46.0],
    [cal_to_jd(1652, 1, 1), 44.0],
    [cal_to_jd(1654, 1, 1), 42.0],
    [cal_to_jd(1656, 1, 1), 40.0],
    [cal_to_jd(1658, 1, 1), 38.0],
    
    [cal_to_jd(1660, 1, 1), 35.0],
    [cal_to_jd(1662, 1, 1), 33.0],
    [cal_to_jd(1664, 1, 1), 31.0],
    [cal_to_jd(1666, 1, 1), 29.0],
    [cal_to_jd(1668, 1, 1), 26.0],

    [cal_to_jd(1670, 1, 1), 24.0],
    [cal_to_jd(1672, 1, 1), 22.0],
    [cal_to_jd(1674, 1, 1), 20.0],
    [cal_to_jd(1676, 1, 1), 28.0],
    [cal_to_jd(1678, 1, 1), 16.0],
    
    [cal_to_jd(1680, 1, 1), 14.0],
    [cal_to_jd(1682, 1, 1), 12.0],
    [cal_to_jd(1684, 1, 1), 11.0],
    [cal_to_jd(1686, 1, 1), 10.0],
    [cal_to_jd(1688, 1, 1), 9.0],
    
    [cal_to_jd(1690, 1, 1), 8.0],
    [cal_to_jd(1692, 1, 1), 7.0],
    [cal_to_jd(1694, 1, 1), 7.0],
    [cal_to_jd(1696, 1, 1), 7.0],
    [cal_to_jd(1698, 1, 1), 7.0],
    
    [cal_to_jd(1700, 1, 1), 7.0],
    [cal_to_jd(1702, 1, 1), 7.0],
    [cal_to_jd(1704, 1, 1), 8.0],
    [cal_to_jd(1706, 1, 1), 8.0],
    [cal_to_jd(1708, 1, 1), 9.0],
    
    [cal_to_jd(1710, 1, 1), 9.0],
    [cal_to_jd(1712, 1, 1), 9.0],
    [cal_to_jd(1714, 1, 1), 9.0],
    [cal_to_jd(1716, 1, 1), 9.0],
    [cal_to_jd(1718, 1, 1), 10.0],
    
    [cal_to_jd(1720, 1, 1), 10.0],
    [cal_to_jd(1722, 1, 1), 10.0],
    [cal_to_jd(1724, 1, 1), 10.0],
    [cal_to_jd(1726, 1, 1), 10.0],
    [cal_to_jd(1728, 1, 1), 10.0],
    
    [cal_to_jd(1730, 1, 1), 10.0],
    [cal_to_jd(1732, 1, 1), 10.0],
    [cal_to_jd(1734, 1, 1), 11.0],
    [cal_to_jd(1736, 1, 1), 11.0],
    [cal_to_jd(1738, 1, 1), 11.0],
    
    [cal_to_jd(1740, 1, 1), 11.0],
    [cal_to_jd(1742, 1, 1), 11.0],
    [cal_to_jd(1744, 1, 1), 12.0],
    [cal_to_jd(1746, 1, 1), 12.0],
    [cal_to_jd(1748, 1, 1), 12.0],
    
    [cal_to_jd(1750, 1, 1), 12.0],
    [cal_to_jd(1752, 1, 1), 13.0],
    [cal_to_jd(1754, 1, 1), 13.0],
    [cal_to_jd(1756, 1, 1), 13.0],
    [cal_to_jd(1758, 1, 1), 14.0],
    
    [cal_to_jd(1760, 1, 1), 14.0],
    [cal_to_jd(1762, 1, 1), 14.0],
    [cal_to_jd(1764, 1, 1), 14.0],
    [cal_to_jd(1766, 1, 1), 15.0],
    [cal_to_jd(1768, 1, 1), 15.0],
    
    [cal_to_jd(1770, 1, 1), 15.0],
    [cal_to_jd(1772, 1, 1), 15.0],
    [cal_to_jd(1774, 1, 1), 15.0],
    [cal_to_jd(1776, 1, 1), 16.0],
    [cal_to_jd(1778, 1, 1), 16.0],
    
    [cal_to_jd(1780, 1, 1), 16.0],
    [cal_to_jd(1782, 1, 1), 16.0],
    [cal_to_jd(1784, 1, 1), 16.0],
    [cal_to_jd(1786, 1, 1), 16.0],
    [cal_to_jd(1788, 1, 1), 16.0],
    
    [cal_to_jd(1790, 1, 1), 16.0],
    [cal_to_jd(1792, 1, 1), 15.0],
    [cal_to_jd(1794, 1, 1), 15.0],
    [cal_to_jd(1796, 1, 1), 14.0],
    [cal_to_jd(1798, 1, 1), 13.0],
    
    [cal_to_jd(1800, 1, 1), 13.1],
    [cal_to_jd(1802, 1, 1), 12.5],
    [cal_to_jd(1804, 1, 1), 12.2],
    [cal_to_jd(1806, 1, 1), 12.0],
    [cal_to_jd(1808, 1, 1), 12.0],
    
    [cal_to_jd(1810, 1, 1), 12.0],
    [cal_to_jd(1812, 1, 1), 12.0],
    [cal_to_jd(1814, 1, 1), 12.0],
    [cal_to_jd(1816, 1, 1), 12.0],
    [cal_to_jd(1818, 1, 1), 11.9],
    
    [cal_to_jd(1820, 1, 1), 11.6],
    [cal_to_jd(1822, 1, 1), 11.0],
    [cal_to_jd(1824, 1, 1), 10.2],
    [cal_to_jd(1826, 1, 1), 9.2],
    [cal_to_jd(1828, 1, 1), 8.2],
    
    [cal_to_jd(1830, 1, 1), 7.1],
    [cal_to_jd(1832, 1, 1), 6.2],
    [cal_to_jd(1834, 1, 1), 5.6],
    [cal_to_jd(1836, 1, 1), 5.4],
    [cal_to_jd(1838, 1, 1), 5.3],
    
    [cal_to_jd(1840, 1, 1), 5.4],
    [cal_to_jd(1842, 1, 1), 5.6],
    [cal_to_jd(1844, 1, 1), 5.9],
    [cal_to_jd(1846, 1, 1), 6.2],
    [cal_to_jd(1848, 1, 1), 6.5],
    
    [cal_to_jd(1850, 1, 1), 6.8],
    [cal_to_jd(1852, 1, 1), 7.1],
    [cal_to_jd(1854, 1, 1), 7.3],
    [cal_to_jd(1856, 1, 1), 7.5],
    [cal_to_jd(1858, 1, 1), 7.6],
    
    [cal_to_jd(1860, 1, 1), 7.7],
    [cal_to_jd(1862, 1, 1), 7.3],
    [cal_to_jd(1864, 1, 1), 6.2],
    [cal_to_jd(1866, 1, 1), 5.2],
    [cal_to_jd(1868, 1, 1), 2.7],
    
    [cal_to_jd(1870, 1, 1), 1.4],
    [cal_to_jd(1872, 1, 1), -1.2],
    [cal_to_jd(1874, 1, 1), -2.8],
    [cal_to_jd(1876, 1, 1), -3.8],
    [cal_to_jd(1878, 1, 1), -4.8],
    
    [cal_to_jd(1880, 1, 1), -5.5],
    [cal_to_jd(1882, 1, 1), -5.3],
    [cal_to_jd(1884, 1, 1), -5.6],
    [cal_to_jd(1886, 1, 1), -5.7],
    [cal_to_jd(1888, 1, 1), -5.9],
    
    [cal_to_jd(1890, 1, 1), -6.0],
    [cal_to_jd(1892, 1, 1), -6.3],
    [cal_to_jd(1894, 1, 1), -6.5],
    [cal_to_jd(1896, 1, 1), -6.2],
    [cal_to_jd(1898, 1, 1), -4.7],
    
    [cal_to_jd(1900, 1, 1), -2.8],
    [cal_to_jd(1902, 1, 1), -0.1],
    [cal_to_jd(1904, 1, 1), 2.6],
    [cal_to_jd(1906, 1, 1), 5.3],
    [cal_to_jd(1908, 1, 1), 7.7],
    
    [cal_to_jd(1910, 1, 1), 10.4],
    [cal_to_jd(1912, 1, 1), 13.3],
    [cal_to_jd(1914, 1, 1), 16.0],
    [cal_to_jd(1916, 1, 1), 18.2],
    [cal_to_jd(1918, 1, 1), 20.2],
    
    [cal_to_jd(1920, 1, 1), 21.1],
    [cal_to_jd(1922, 1, 1), 22.4],
    [cal_to_jd(1924, 1, 1), 23.5],
    [cal_to_jd(1926, 1, 1), 23.8],
    [cal_to_jd(1928, 1, 1), 24.3],
    
    [cal_to_jd(1930, 1, 1), 24.0],
    [cal_to_jd(1932, 1, 1), 23.9],
    [cal_to_jd(1934, 1, 1), 23.9],
    [cal_to_jd(1936, 1, 1), 23.7],
    [cal_to_jd(1938, 1, 1), 24.0],
    
    [cal_to_jd(1940, 1, 1), 24.3],
    [cal_to_jd(1942, 1, 1), 25.3],
    [cal_to_jd(1944, 1, 1), 26.2],
    [cal_to_jd(1946, 1, 1), 27.3],
    [cal_to_jd(1948, 1, 1), 28.2],
    
    [cal_to_jd(1950, 1, 1), 29.1],
    [cal_to_jd(1952, 1, 1), 30.0],
    [cal_to_jd(1954, 1, 1), 30.7],
    [cal_to_jd(1956, 1, 1), 31.4],
    [cal_to_jd(1958, 1, 1), 32.2],
    
    [cal_to_jd(1960, 1, 1), 33.1],
    [cal_to_jd(1962, 1, 1), 34.0],
    [cal_to_jd(1964, 1, 1), 35.0],
    [cal_to_jd(1966, 1, 1), 36.5],
    [cal_to_jd(1968, 1, 1), 38.3],
    
    [cal_to_jd(1970, 1, 1), 40.2],
    [cal_to_jd(1972, 1, 1), 42.2],
    [cal_to_jd(1974, 1, 1), 44.5],
    [cal_to_jd(1976, 1, 1), 46.5],
    [cal_to_jd(1978, 1, 1), 48.5],
    
    [cal_to_jd(1980, 1, 1), 50.5],
    [cal_to_jd(1982, 1, 1), 52.2],
    [cal_to_jd(1984, 1, 1), 53.8],
    [cal_to_jd(1986, 1, 1), 54.9],
    [cal_to_jd(1988, 1, 1), 55.8],
    
    [cal_to_jd(1990, 1, 1), 56.9],
    [cal_to_jd(1992, 1, 1), 58.3],
    [cal_to_jd(1994, 1, 1), 60.0],
    [cal_to_jd(1996, 1, 1), 61.6],
    [cal_to_jd(1998, 1, 1), 63.0],
    
    #  the following are not from Meeus, but are taken from
    # http://hpiers.obspm.fr/eop-pc/earthor/ut1lod/ut1-tai.html
    [cal_to_jd(2000, 1, 1), 32.184 + 31.6445],
    [cal_to_jd(2002, 1, 1), 32.184 + 32.1158],
    [cal_to_jd(2004, 1, 1), 32.184 + 32.3896],
    [cal_to_jd(2006, 1, 1), 32.184 + 32.6612],
    [cal_to_jd(2008, 1, 1), 32.184 + 33.2733],
    [cal_to_jd(2010, 1, 1), 32.184 + 33.897],
    [cal_to_jd(2012, 1, 1), 32.184 + 34.511] 
}

deltat_table_start = 1620
deltat_table_end = 2012

#=

deltaT_seconds(jd)

Return deltaT as seconds of time. 
    
    For a historical range from 1620 to a recent year, we interpolate from a
    table of observed values. Outside that range we use formulae.
    
    Parameters:
        jd : Julian Day number
    Returns:
        deltaT in seconds

=# 

function deltaT_seconds(jd::Float64)
    yr, mo, day = jd_to_cal(jd)
    jd1, jd0, secs1, secs0 = (0,0,0,0)
    #
    # 1620 - 20xx - do linear interpolation
    #
    if yr == deltat_table_end 
    	return deltat_table_end[deltat_table][1]
    end
    
    if deltat_table_start <= yr && yr < deltat_table_end 
    
    # linear search to find entries that bracket our target date. We could
    # improve this with a binary search or some sort of index.
    # TODO deltaT_seconds() improve crappy code
    for (i, j) in enumerate(deltat_table[1:end-1])
      if jd >= deltat_table[i][1] && jd < deltat_table[i+1][1]
        jd1, secs1 = deltat_table[i+1][1:2]
        jd0, secs0 = deltat_table[i][1:2]
      end
    end
    #  simple linear interpolation between two values
    return ((jd - jd0) * (secs1 - secs0) / (jd1 - jd0)) + secs0 
    end

    t = (yr - 2000) / 100.0
    
    #
    # before 948 [Meeus-1998: equation 10.1]
    #
    if yr < 948 
      return polynomial([2177, 497, 44.1], t)
    end

    #
    # 948 - 1620 and after 2012 [Meeus-1998: equation 10.2)
    #
    result = polynomial([102, 102, 25.3], t)
    
    #
    # correction for 2012-2100 [Meeus-1998: pg 78]
    #  
    if deltat_table_end <= yr && yr < 2100 
      result = result + 0.37 * (yr - 2100)
    end
    return result
end

#=
dt_to_ut(jd)

Convert Julian Day from dynamical to terrestrial universal time.
    
    Parameters:
        jd : Julian Day number (dynamical time)
    Returns:
        Julian Day number (universal time)

=#
function dt_to_ut(jd::Float64)
    global seconds_per_day
    return jd - deltaT_seconds(jd) / seconds_per_day
end 

#=
tdt_to_bdt(tt, jd)

Converts from terrestrial dynamic time to barycentric dynamic time
    
    Parameters:
     tt : terrestrial dynamic time
     jd : Julian Day number (terrestrial dynamic time)
    Returns:
              barycentric dynamic time

=#

function tdt_to_bdt(tt, jd)
    g = 357.33 + 0.9856003*(jd-2451545)
    tdb = tt + 0.001658*sin(g) + 0.000014*sin(2*g)
    return tdb
end 
