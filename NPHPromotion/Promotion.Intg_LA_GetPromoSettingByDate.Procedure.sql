DROP PROCEDURE IF EXISTS Promotion.Intg_LA_GetPromoSettingByDate;
DELIMITER //

CREATE DEFINER=`NPHP_admin`@`%` PROCEDURE Promotion.Intg_LA_GetPromoSettingByDate(
	IN PromoDate DATE
)
SQL SECURITY DEFINER
BEGIN
	/*
		Creator: Bobby@20191217
		Parameters Explanation:
			- PromoDate DATE: The day to receive the program
			
		Revisions:
			- 20191217@Bobby: Get Promotion setting [RedmineID: #119417]
		
	*/
	       
	SELECT p.PromoId
		, p.StartDate
		, p.EndDate
		, p.OffPeakStartTime
		, p.OffPeakEndTime
		, cs.CurrencyID
		, COUNT(1) AS CouponCount
	FROM Promotion.NPHPromotion p
	INNER JOIN Promotion.NPHPromoCurrSetting cs	ON cs.PromoID = p.PromoId
	LEFT JOIN Promotion.NPHPromoCoupon pc ON cs.PromoID = p.PromoId	AND cs.CurrencyID = pc.CurrencyID
	WHERE PromoDate BETWEEN p.StartDate AND p.EndDate
	GROUP BY p.PromoId
		, p.StartDate
		, p.EndDate
		, p.OffPeakStartTime
		, p.OffPeakEndTime
		, cs.CurrencyID;
END;

//
DELIMITER ;
GRANT EXECUTE ON PROCEDURE Promotion.Intg_LA_GetPromoSettingByDate TO 'sqlLink'@'%';