-- source https://github.com/liuxin-reg/idempiere
CREATE OR REPLACE
FUNCTION nextbusinessday(p_date timestamp WITH time ZONE) RETURNS timestamp WITH time ZONE AS $$ 
DECLARE v_nextDate date := trunc(p_Date + 1);

v_offset NUMERIC := 0;

v_Saturday NUMERIC := TO_CHAR(TO_DATE('2000-01-01', 'YYYY-MM-DD'), 'D');

v_Sunday NUMERIC :=
(CASE
	WHEN v_Saturday = 7 THEN 1
	ELSE v_Saturday + 1
END);

v_isHoliday boolean := TRUE;

nbd non_business_days%ROWTYPE;

BEGIN v_isHoliday := TRUE;

LOOP
SELECT
	CASE TO_CHAR(v_nextDate, 'D')::NUMERIC
	WHEN v_Saturday THEN 2
	WHEN v_Sunday THEN 1
	ELSE 0
END
INTO
	v_offset;

v_nextDate := v_nextDate + v_offset::integer;

v_isHoliday := FALSE;

FOR nbd IN
SELECT
	*
FROM
	non_business_days
WHERE
	holyday >= v_nextDate
ORDER BY
	holyday LOOP EXIT
	WHEN v_nextDate <> trunc(nbd.holyday);

v_nextDate := v_nextDate + 1;

v_isHoliday := TRUE;
END LOOP;

EXIT
WHEN v_isHoliday = FALSE;
END LOOP;
--
 RETURN v_nextDate::timestamp WITH time ZONE;
END;

$$ LANGUAGE plpgsql STABLE;

