%let pgm=utl-how-to-check-for-a-palindrome-using-sql-wps-python-r;

How to check for a palindrome using sql wps python r

github
https://tinyurl.com/2p8m7d57
https://github.com/rogerjdeangelis/utl-how-to-check-for-a-palindrome-using-sql-wps-python-r

How to check for a palindrome using sql wps python r

 FOUR SOLUTIONS

    1 wps sql
      when (trim(word) = strip(reverse(word))) then 'YES'
      else  'NO'
      end as palindrome

    2 wps r sql
      when (trim(word) = strip(reverse(word))) then 'YES'
      else  'NO'
      end as palindrome

    3 wps python sql
      when (trim(word) = strip(reverse(word))) then 'YES'
      else  'NO'
      end as palindrome

    4.wps r native
      have$REV <-stri_reverse(str_trim(have$WORD));
      want <- have %>%
        mutate(PALIDROME = ifelse (WORD == REV,"YES","NO"));

    5 wps python native
      have['REVERSE']    = have.loc[:,'WORD'].apply(lambda x: x[::-1]) ;
      have['PALINDROME'] = have.loc[:,'REVERSE'].str.strip()==have.loc[:,'WORD'].str.strip() ;

related
https://stackoverflow.com/questions/17331290/how-to-check-for-palindrome-using-python-logic

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/
options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
input word $8.;
cards4;
rotor
roter
racecar
civic
carta
level
kayak
cubic
;;;;
run;quit;

/*                                  _
/ | __      ___ __  ___   ___  __ _| |
| | \ \ /\ / / `_ \/ __| / __|/ _` | |
| |  \ V  V /| |_) \__ \ \__ \ (_| | |
|_|   \_/\_/ | .__/|___/ |___/\__, |_|
             |_|                 |_|
*/
proc datasets lib=sd1 nolist nodetails;delete want; run;quit;

%utl_submit_wps64x("
options validvarname=any;
libname sd1 'd:/sd1';
proc sql;
  create
     table sd1.want as
  select
     word
    ,reverse(word) as word_rev
    ,case
      when (trim(word) = strip(reverse(word))) then 'YES'
      else  'NO'
     end as palindrome
  from
     sd1.have
;quit;
 proc print data=sd1.want;
 run;quit;
");

*/ /*************************************************************************************************************************
*/ /*
*/ /*
*/ /* The WPS System
*/ /*
*/ /* Obs     WORD      word_rev    palindrome
*/ /*
*/ /*  1     rotor        rotor        YES
*/ /*  2     roter        retor        NO
*/ /*  3     racecar    racecar        YES
*/ /*  4     civic        civic        YES
*/ /*  5     carta        atrac        NO
*/ /*  6     level        level        YES
*/ /*  7     kayak        kayak        YES
*/ /*  8     cubic        cibuc        NO
*/ /*
*/ /*
*/ /*************************************************************************************************************************

/*___                                          _
|___ \  __      ___ __  ___   _ __   ___  __ _| |
  __) | \ \ /\ / / `_ \/ __| | `__| / __|/ _` | |
 / __/   \ V  V /| |_) \__ \ | |    \__ \ (_| | |
|_____|   \_/\_/ | .__/|___/ |_|    |___/\__, |_|
                 |_|                        |_|
*/
proc datasets lib=sd1 nolist nodetails;delete want; run;quit;

options validvarname=any;
libname sd1 "d:/sd1";

%utl_submit_wps64x('
libname sd1 "d:/sd1";
proc r;
export data=sd1.have r=have;
submit;
library(sqldf);
want<-sqldf("
  select
     word
    ,reverse(word) as word_rev
    ,case
      when (word = reverse(word)) then \"YES\"
      else  \"NO\"
     end as palindrome
  from
     have
");
want;
endsubmit;
import data=sd1.want r=want;
run;quit;
');

proc print data=sd1.want width=min;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  The WPS System                                                                                                        */
/*                                                                                                                        */
/*       WORD word_rev palindrome                                                                                         */
/*                                                                                                                        */
/*  1   rotor    rotor        YES                                                                                         */
/*  2   roter    retor         NO                                                                                         */
/*  3 racecar  racecar        YES                                                                                         */
/*  4   civic    civic        YES                                                                                         */
/*  5   carta    atrac         NO                                                                                         */
/*  6   level    level        YES                                                                                         */
/*  7   kayak    kayak        YES                                                                                         */
/*  8   cubic    cibuc         NO                                                                                         */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*____                                    _   _                             _
|___ /  __      ___ __  ___   _ __  _   _| |_| |__   ___  _ __    ___  __ _| |
  |_ \  \ \ /\ / / `_ \/ __| | `_ \| | | | __| `_ \ / _ \| `_ \  / __|/ _` | |
 ___) |  \ V  V /| |_) \__ \ | |_) | |_| | |_| | | | (_) | | | | \__ \ (_| | |
|____/    \_/\_/ | .__/|___/ | .__/ \__, |\__|_| |_|\___/|_| |_| |___/\__, |_|
                 |_|         |_|    |___/                                |_|
*/

proc datasets lib=sd1 nolist nodetails;delete want; run;quit;

libname sd1 "d:/sd1";

%utl_submit_wps64x("
options validvarname=any lrecl=32756;
libname sd1 'd:/sd1';
proc python;
export data=sd1.have python=have;
submit;
import pyreadstat as pr;
from os import path;
import pandas as pd;
import numpy as np;
from pandasql import sqldf;
mysql = lambda q: sqldf(q, globals());
from pandasql import PandaSQL;
pdsql = PandaSQL(persist=True);
sqlite3conn = next(pdsql.conn.gen).connection.connection;
sqlite3conn.enable_load_extension(True);
sqlite3conn.load_extension('c:/temp/libsqlitefunctions.dll');
mysql = lambda q: sqldf(q, globals());
want = pdsql('''
  select
     word
    ,reverse(word) as word_rev
    ,case
      when (trim(word) = trim(reverse(word))) then `YES`
      else  `NO`
     end as palindrome
  from
     have
''');
print(want);
pr.write_xport(want, 'd:/xpt/want.xpt',table_name='want',file_format_version=5);
endsubmit;
run;quit;
");

libname xpt xport "d:/xpt/want.xpt";
proc contents data=xpt._all_;
run;quit;
data want;
  set xpt.want;
run;quit;
proc print;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*     WORD      WORD_REV    PALINDRO                                                                                     */
/*                                                                                                                        */
/*    rotor        rotor       YES                                                                                        */
/*    roter        retor       NO                                                                                         */
/*    racecar    racecar       YES                                                                                        */
/*    civic        civic       YES                                                                                        */
/*    carta        atrac       NO                                                                                         */
/*    level        level       YES                                                                                        */
/*    kayak        kayak       YES                                                                                        */
/*    cubic        cibuc       NO                                                                                         */
/*                                                                                                                        */
/**************************************************************************************************************************/


/*  _                                             _   _
| || |   __      ___ __  ___   _ __   _ __   __ _| |_(_)_   _____
| || |_  \ \ /\ / / `_ \/ __| | `__| | `_ \ / _` | __| \ \ / / _ \
|__   _|  \ V  V /| |_) \__ \ | |    | | | | (_| | |_| |\ V /  __/
   |_|     \_/\_/ | .__/|___/ |_|    |_| |_|\__,_|\__|_| \_/ \___|
                  |_|
*/

proc datasets lib=sd1 nolist nodetails;delete want; run;quit;

options validvarname=any;
libname sd1 "d:/sd1";

%utl_submit_wps64x('
libname sd1 "d:/sd1";
proc r;
export data=sd1.have r=have;
submit;
library(dplyr);
library(stringi);
library(stringr);
have$REV <-stri_reverse(str_trim(have$WORD));
want <- have %>%
  mutate(PALIDROME = ifelse (WORD == REV,"YES","NO"));
want;
endsubmit;
import data=sd1.want r=want;
run;quit;
');

proc print data=sd1.want width=min;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  The WPS System                                                                                                        */
/*                                                                                                                        */
/*       WORD     REV PALIDROME                                                                                           */
/*  1   rotor   rotor       YES                                                                                           */
/*  2   roter   retor        NO                                                                                           */
/*  3 racecar racecar       YES                                                                                           */
/*  4   civic   civic       YES                                                                                           */
/*  5   carta   atrac        NO                                                                                           */
/*  6   level   level       YES                                                                                           */
/*  7   kayak   kayak       YES                                                                                           */
/*  8   cubic   cibuc        NO                                                                                           */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___                                     _   _                              _   _
| ___|  __      ___ __  ___   _ __  _   _| |_| |__   ___  _ __   _ __   __ _| |_(_)_   _____
|___ \  \ \ /\ / / `_ \/ __| | `_ \| | | | __| `_ \ / _ \| `_ \ | `_ \ / _` | __| \ \ / / _ \
 ___) |  \ V  V /| |_) \__ \ | |_) | |_| | |_| | | | (_) | | | || | | | (_| | |_| |\ V /  __/
|____/    \_/\_/ | .__/|___/ | .__/ \__, |\__|_| |_|\___/|_| |_||_| |_|\__,_|\__|_| \_/ \___|
                 |_|         |_|    |___/
*/

%utl_submit_wps64x("
options validvarname=any lrecl=32756;
libname sd1 'd:/sd1';
proc python;
export data=sd1.have python=have;
submit;
have['REVERSE']    = have.loc[:,'WORD'].apply(lambda x: x[::-1]) ;
have['PALINDROME'] = have.loc[:,'REVERSE'].str.strip()==have.loc[:,'WORD'].str.strip() ;
print(have);
have.info();
endsubmit;
run;quit;
");

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  The WPS Python System                                                                                                 */
/*                                                                                                                        */
/*         WORD   REVERSE  PALINDROME                                                                                     */
/*  0  rotor        rotor        True                                                                                     */
/*  1  roter        retor       False                                                                                     */
/*  2  racecar    racecar        True                                                                                     */
/*  3  civic        civic        True                                                                                     */
/*  4  carta        atrac       False                                                                                     */
/*  5  level        level        True                                                                                     */
/*  6  kayak        kayak        True                                                                                     */
/*  7  cubic        cibuc       False                                                                                     */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/

