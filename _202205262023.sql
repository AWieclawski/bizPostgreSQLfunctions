-- source https://github.com/liuxin-reg/idempiere
CREATE OR REPLACE FUNCTION addDays(datetime TIMESTAMP WITH TIME ZONE, days Numeric)
RETURNS DATE AS $$
declare duration varchar;
BEGIN
	if datetime is null or days is null then
		return null;
	end if;
	duration = days || ' day';	 
	return cast(date_trunc('day',datetime) + cast(duration as interval) as date);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION subtractdays (day TIMESTAMP WITH TIME ZONE, days NUMERIC)
RETURNS DATE AS $$
BEGIN
    RETURN addDays(day,(days * -1));
END;
$$ LANGUAGE plpgsql IMMUTABLE;


DROP OPERATOR + (timestamptz, NUMERIC);
CREATE OPERATOR + ( PROCEDURE = adddays,
LEFTARG = TIMESTAMPTZ, RIGHTARG = NUMERIC,
COMMUTATOR = +);

DROP OPERATOR - (timestamptz, NUMERIC);
CREATE OPERATOR - ( PROCEDURE = subtractdays,
LEFTARG = TIMESTAMPTZ, RIGHTARG = NUMERIC,
COMMUTATOR = -);
