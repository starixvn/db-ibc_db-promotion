DROP PROCEDURE IF EXISTS Promotion.Intg_LA_GetPromoSettingByRangeDate;
DELIMITER //

CREATE DEFINER=`NPHP_admin`@`%` PROCEDURE Promotion.Intg_LA_GetPromoSettingByRangeDate(
	IN FromDate DATE,
	IN ToDate DATE
)
SQL SECURITY DEFINER
BEGIN
	/*
		Creator: Bobby@20191217
		Parameters Explanation:
			- FromDate DATE: The day that the program start
			- ToDate DATE: The day that the program end
			
		Revisions:
			- 20191217@Bobby: Get Promotion setting [RedmineID: #119417]
		
	*/
	       
	SELECT p.PromoId
		, p.StartDate
		, p.EndDate
		, p.OffPeakStartTime
		, p.OffPeakEndTime
		, cs.CurrencyID
		, SUM(CASE WHEN pc.CouponID > 0 THEN 1 ELSE 0 END) AS CouponCount
	FROM Promotion.NPHPromotion p
	INNER JOIN Promotion.NPHPromoCurrSetting cs	ON cs.PromoID = p.PromoId
	LEFT JOIN Promotion.NPHPromoCoupon pc ON p.PromoID = pc.PromoId AND cs.CurrencyID = pc.CurrencyID
	WHERE FromDate BETWEEN p.StartDate AND p.EndDate OR ToDate BETWEEN p.StartDate AND p.EndDate
	GROUP BY p.PromoId
		, p.StartDate
		, p.EndDate
		, p.OffPeakStartTime
		, p.OffPeakEndTime
		, cs.CurrencyID;
END;

//
DELIMITER ;
GRANT EXECUTE ON PROCEDURE Promotion.Intg_LA_GetPromoSettingByRangeDate TO 'sqlLink'@'%';