DROP PROCEDURE IF EXISTS `Promotion.Intg_LA_GetPromoSummary`;
DELIMITER //

CREATE DEFINER=`NPHP_admin`@`%` PROCEDURE `Promotion.Intg_LA_GetPromoSummary`(
	IN Winlostdate DATE
)
SQL SECURITY DEFINER
BEGIN
	/*
		Creator: Bobby@20191119
		Parameters Explanation:
			- winlostdate DATE: The day to receive the summary report data
			
		Revisions:
			- 20191119@Bobby:  Generate SUM data fro LA reporting [RedmineID: #119417]
		
	*/
	       
	SELECT p.PromoID
		,p.StartDate
		,p.EndDate
		,p.OffPeakStartTime
		,p.OffPeakEndTime
		,c.CustID
		,c.CurrencyID
        ,c.PromoDay AS CouponDate
        ,8 AS CouponTimeZone 
        ,CONVERT(ADDTIME(c.CreateTime, '12:00:00'), DATE) AS CouponDateGMT
		,COUNT(c.couponID) AS CouponCount
		,SUM(c.Redeemed) AS RedemptionCount
		,SUM(CASE WHEN c.Redeemed = 1 THEN c.Prize ELSE 0 END) AS RedemptionPrize
	FROM NPHPromotion AS p
	LEFT JOIN NPHPromoCoupon c ON p.PromoID = c.PromoID AND c.PromoDay = Winlostdate
	WHERE Winlostdate >= p.StartDate AND Winlostdate <= p.EndDate
	GROUP BY p.PromoID
		,p.StartDate
		,p.EndDate
		,p.OffPeakStartTime
		,p.OffPeakEndTime
		,c.CustID
		,c.CurrencyID
        ,CONVERT(c.CreateTime, DATE)
        ,CONVERT(ADDTIME(c.CreateTime, '12:00:00'), DATE)
	;
END;

//
DELIMITER ;
GRANT EXECUTE ON PROCEDURE Promotion.Intg_LA_GetPromoSummary TO 'sqlLink'@'%';