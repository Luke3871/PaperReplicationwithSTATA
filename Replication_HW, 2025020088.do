/*==============================================================================
 # Pre-processing
 - 결측치가 존재하거나, 4분기가 온전하지 않으면 분석에 사용하지 않음 (1)
 - 5년 연속 데이터가 존재하지 않는 회사는 분석에 사용하지 않음 (2)
 - 회계년도가 1년 이상 끊어져 있다면 분석에 사용하지 않음 (3)
 - 최초 2년의 데이터는 분석에 사용하지 않음 -> Sales Surprise 변수 계산 시 제거 (4)
 =============================================================================*/
 
 /*===================================
 # 분기 데이터 전처리
 ===================================*/
 
// 1985 ~ 2000 (row - 18,840)
	use "C:\Users\lluke\OneDrive\바탕 화면\Q1985.dta"
	describe
	
	// 활용할 년도 제외 제거 (193rows deleted)
	keep if fyear >= 1985 & fyear <= 2000
	/*--------------------------------------------------------------------------
	(1) 결측치가 존재하거나, 4분기가 온전하지 않으면 분석에 사용하지 않음
	--------------------------------------------------------------------------*/
	
	/*--------------------------------------------------------------------------
	이대로 하면 4분기에만 데이터가 남는 기업이 다수 존재,
	논문에서 1/4를 명시한 것의 이유는 4분기가 온전해야 분석에 사용
	// invtq가 결측 이거나 0일 경우
	
	// 분기별 그룹핑하여 관측치 저장
	egen quarter_group = group(gvkey fyear)
	egen obs = count(fqtr), by(quarter_group)
	
	// invtq가 결측 또는 0일 경우 1반환
	gen temp_i = missing(invtq) | invtq == 0
	
	// 각 분기 그룹별로 반환된 값을 sum (4개의 분기 중 3개가 결측 또는 0일 경우 3 반환)
	egen sum_i = total(temp_i), by(quarter_group)
	
	// 합한 값이 관측 값과 같을 경우 1 반환
	gen invtq_flag = (sum_i == obs)
	
	// ppegtq가 결측 또는 0일 경우
	gen temp_p = missing(ppegtq) | ppegtq == 0
	egen sum_p = total(temp_p), by(quarter_group)
	gen ppegtq_flag = (sum_p == obs)
	
		// drop flag 생성하여 결측치 삭제 row 반환, 둘 중 하나라도 1 이면 1 반환
		gen drop_group = invtq_flag | ppegtq_flag
		
		// 쿼터 그룹 전체 삭제 (flag == 1)
		egen keep_flag = max(drop_group), by(quarter_group)
		drop if keep_flag == 1
		
		// 0인 값들은 결측치로 대체
		replace invtq =. if invtq == 0
		replace ppegtq =. if ppegtq == 0
		drop quarter_group obs temp_i sum_i invtq_flag temp_p sum_p ppegtq_flag drop_group keep_flag

------------------------------------------------------------------------------*/		
	// invtq 또는 ppegtq가 하나라도 결측일 경우 제거 (6,536 rows deleted)
	drop if missing(invtq) | missing(ppegtq)

	/*--------------------------------------------------------------------------
	4분기가 온전하지 않으면 분석에 사용하지 않음 -> 너무 많은 row가 제거되어 보류
	gvkey와 fyear 활용하여 그룹 생성 및 obs = 4 이외 제거 (1,159 rows deleted)
	egen quarter_group = group(gvkey fyear)
	egen obs = count(fqtr), by(quarter_group)
	keep if obs == 4
	--------------------------------------------------------------------------*/
	
	// 평균 변수 생성
	collapse (mean) invtq ppegtq, by(gvkey fyear)
	
	// invtq가 0인 경우 제거 (152 rows deleted)
	drop if invtq == 0
	
	// invtq + ppegtq = 0인 경우 제거 (0 rows deleted)
	drop if invtq + ppegtq == 0
	
	// ppegtq <= 0일 경우 log_CI 활용 불가 (0 rows deleted)
	drop if ppegtq <= 0
	
	// 변수명 변경 & 중복값 있는지 확인 및 제거
	rename fyearq fyear
	duplicates report gvkey fyear
	//duplicates drop, force 이 데이터셋에는 없음
	
	//저장, 4,482 rows
	describe
	save "Q1985_AVG.dta", replace

//============================================================================//	
// 2001 ~ 2015 (rows, 12,519)
	use "C:\Users\lluke\OneDrive\바탕 화면\Q2001.dta"
	describe
	
	// 활용할 년도 제외 제거 (165 rows deleted)
	keep if fyear >= 2001 & fyear <= 2015
	
	/*--------------------------------------------------------------------------
	(1) 결측치가 존재하거나, 4분기가 온전하지 않으면 분석에 사용하지 않음
	--------------------------------------------------------------------------*/
	

	
/*------------------------------------------------------------------------------
 이대로 하면 4분기에만 데이터가 남는 기업이 다수 존재, 
 논문에서 1/4를 명시한 것의 이유는 4분기가 온전해야 분석에 사용
	// invtq가 결측 이거나 0일 경우
	
	// 분기별 그룹핑하여 관측치 저장
	egen quarter_group = group(gvkey fyear)
	egen obs = count(fqtr), by(quarter_group)
	
	// invtq가 결측 또는 0일 경우 1반환
	gen temp_i = missing(invtq) | invtq == 0
	
	// 각 분기 그룹별로 반환된 값을 sum (4개의 분기 중 3개가 결측 또는 0일 경우 3 반환)
	egen sum_i = total(temp_i), by(quarter_group)
	
	// 합한 값이 관측 값과 같을 경우 1 반환
	gen invtq_flag = (sum_i == obs)
	
	// ppegtq가 결측 또는 0일 경우
	gen temp_p = missing(ppegtq) | ppegtq == 0
	egen sum_p = total(temp_p), by(quarter_group)
	gen ppegtq_flag = (sum_p == obs)
	
		// drop flag 생성하여 결측치 삭제 row 반환, 둘 중 하나라도 1 이면 1 반환
		gen drop_group = invtq_flag | ppegtq_flag
		
		// 쿼터 그룹 전체 삭제 (flag == 1)
		egen keep_flag = max(drop_group), by(quarter_group)
		drop if keep_flag == 1
		
		// 0인 값들은 결측치로 대체
		replace invtq =. if invtq == 0
		replace ppegtq =. if ppegtq == 0
		drop quarter_group obs temp_i sum_i invtq_flag temp_p sum_p ppegtq_flag drop_group keep_flag

------------------------------------------------------------------------------*/		
	
	
	// invtq 또는 ppegtq가 하나라도 결측일 경우 제거 (6,089 rows deleted)
	drop if missing(invtq) | missing(ppegtq)
	
	

	/*--------------------------------------------------------------------------
	4분기가 온전하지 않으면 분석에 사용하지 않음 -> 너무 많은 row가 제거되어 보류
	gvkey와 fyear 활용하여 그룹 생성 및 obs = 4 이외 제거 (1,159 rows deleted)
	egen quarter_group = group(gvkey fyear)
	egen obs = count(fqtr), by(quarter_group)
	keep if obs == 4
	--------------------------------------------------------------------------*/
	
	// 평균 변수 생성
	collapse (mean) invtq ppegtq, by(gvkey fyear)
	
	// invtq가 0인 경우 제거(104 rows deleted)
	drop if invtq == 0
	
	// invtq + ppegtq = 0인 경우 제거 (0 rows deleted)
	drop if invtq + ppegtq == 0
	
	// ppegtq <= 0일 경우 log_CI 활용 불가 (2 rows deleted)
	drop if ppegtq <= 0
	
	// 변수명 변경 & 중복값 있는지 확인 및 제거
	rename fyearq fyear
	duplicates report gvkey fyear
	//duplicates drop, force 이 데이터셋에는 없음
	
	// 저장, 2,874 rows
	describe
	save "Q2001_AVG.dta", replace
	
 /*===================================
 # 연간 데이터 전처리
 ===================================*/

// 1985 ~ 2000 (row - 5,021)
	use "C:\Users\lluke\OneDrive\바탕 화면\A1985.dta"
	describe
	
	// 활용할 년도 제외 제거 (155rows deleted)
	keep if fyear >= 1985 & fyear <= 2000
	
	// (1) 결측치가 존재하면 분석에 사용하지 않음 (513 rows deleted)
	// 파생 변수를 만드는 과정에서 cogs <= 0 이면 log term 활용불가 & sale이 <= 0 이면 GM, log_SS 계산 불가 & sale - cogs가 0보다 작으면 log term 활용 불가
	drop if missing(cogs) | missing(sale) | cogs <= 0 | sale <= 0 | (sale - cogs) < 0
	
	// 중복값 있는지 확인 및 제거
	duplicates report gvkey fyear
	//duplicates drop, force 이 데이터 셋에는 없음
	
	//저장, 4,353 rows
	describe
	save "A1985_cleaned.dta", replace
	
//============================================================================//	
// 2001 ~ 2015 (row - 3,124)
	use "C:\Users\lluke\OneDrive\바탕 화면\A2001.dta"
	describe
	
	// 활용할 년도 제외 제거 (5 rows deleted)
	keep if fyear >= 2000 & fyear <= 2015
	
	// (1) 결측치가 존재하면 분석에 사용하지 않음 (175 rows deleted)
	// 파생 변수를 만드는 과정에서 cogs <= 0 이면 log term 활용불가 & sale이 <= 0 이면 GM, log_SS 계산 불가 & sale - cogs가 0보다 작으면 log term 활용 불가
	drop if missing(cogs) | missing(sale) | cogs <= 0 | sale <= 0 | (sale - cogs) < 0
	
	// 중복값 있는지 확인 및 제거
	duplicates report gvkey fyear
	//duplicates drop, force 이 데이터 셋에는 없음
	
	//저장, 2,944 rows
	describe
	save "A2001_cleaned.dta", replace
	
	
 /*===================================
 # 병합
 ===================================*/

 // 1985 ~ 2000 merge
	use "A1985_cleaned.dta", clear
	
	// 1대1 병합 gvkey, fyear (4,704 rows)
	merge 1:1 gvkey fyear using "Q1985_AVG.dta"
	describe
	
	// (1) 결측치 제거 (570 rows deleted)
	drop if missing(invtq) | missing(ppegtq) | missing(cogs) | missing(sale)
	
	// 저장 (4,131 rows)
	describe
	save "1985_cleaned.dta", replace
	
//============================================================================//	
// 2001 ~ 2015 merge
	use "A2001_cleaned.dta", clear
	
	// 1대1 병합 gvkey, fyear (3,101 rows)
	merge 1:1 gvkey fyear using "Q2001_AVG.dta"
	describe
	
	// (1) 결측치 제거 (374 rows deleted)
	drop if missing(invtq) | missing(ppegtq) | missing(cogs) | missing(sale)
	
	// 저장 (2,717 rows)
	describe
	save "2001_cleaned.dta", replace
	
 /*=============================================================================
 # SIC 코드 라벨링 및 변수 생성
 - SIC코드 라벨링 (1)
 - 분석에 활용되는 변수 생성 IT, GM, CI (2)
 =============================================================================*/	

 // 1985 ~ 2000 Data set	
	// SIC코드 라벨링 (1)
	use "1985_cleaned.dta", clear
	destring sic, replace
	
	// 문자형 파생변수 생성
	gen str50 segment = ""
	
	replace segment = "Apparel and accessory stores"							if sic >= 5600 & sic <= 5699
	replace segment = "Catalog, mail-order houses" 								if sic == 5961
	replace segment = "Department stores" 										if sic == 5311
	replace segment = "Drug and proprietary stores" 							if sic == 5912
	replace segment = "Food stores" 											if sic == 5400 | sic == 5411
	replace segment = "Hobby, toy, and game shops" 								if sic == 5945
	replace segment = "Home furmiture and equip stores"							if sic == 5700
	replace segment = "Jewelry stores" 											if sic == 5944
	replace segment = "Radio, TV, consumer electronics stores"					if sic == 5731
	replace segment = "Variety stores"											if sic == 5331

	// 분석에 활용되는 변수 생성 (2)
	// 재고 회전율 (Inventory Turnover, IT)
	gen IT = cogs/invtq
	gen log_IT = log(IT)
	
	// 총 이익률 (Gross Margin, GM)
	gen GM = (sale - cogs) / sale
	gen log_GM = log(GM)
	
	// 자본집약도 (Capital Intensity, CI)
	gen CI = ppegtq / (invtq + ppegtq)
	gen log_CI = log(CI)
	save "1985_cleaned_var.dta", replace
	
//============================================================================//	
// 2001 ~ 2015 Data set
	// SIC코드 라벨링 (1)
	use "2001_cleaned.dta", clear
	destring sic, replace
	
	// 문자형 파생변수 생성
	gen str50 segment = ""
	
	replace segment = "Apparel and accessory stores"							if sic >= 5600 & sic <= 5699
	replace segment = "Catalog, mail-order houses" 								if sic == 5961
	replace segment = "Department stores" 										if sic == 5311
	replace segment = "Drug and proprietary stores" 							if sic == 5912
	replace segment = "Food stores" 											if sic == 5400 | sic == 5411
	replace segment = "Hobby, toy, and game shops" 								if sic == 5945
	replace segment = "Home furmiture and equip stores"							if sic == 5700
	replace segment = "Jewelry stores" 											if sic == 5944
	replace segment = "Radio, TV, consumer electronics stores"					if sic == 5731
	replace segment = "Variety stores"											if sic == 5331

	// 분석에 활용되는 변수 생성 (2)
	// 재고 회전율 (Inventory Turnover, IT)
	gen IT = cogs/invtq
	gen log_IT = log(IT)
	
	// 총 이익률 (Gross Margin, GM)
	gen GM = (sale - cogs) / sale
	gen log_GM = log(GM)
	
	// 자본집약도 (Capital Intensity, CI)
	gen CI = ppegtq / (invtq + ppegtq)
	gen log_CI = log(CI)	
	save "2001_cleaned_var.dta", replace
	
 /*=============================================================================
 # 논문의 전처리
 - 최초 2년의 데이터는 분석에 사용하지 않음, SS 변수 생성 (2)
 - 5년 연속 데이터가 존재하지 않는 회사는 분석에 사용하지 않음 (3)
 - 회계년도가 1년 이상 끊어져 있다면 분석에 사용하지 않음 (4)
 - * FIFO <-> LIFO 등의 재고평가법 전환은 논문에서도 3개의 case만 존재, 특별히 진행하지 않음 
 =============================================================================*/

// 1985 ~ 2000 data set
	use "1985_cleaned_var.dta", clear
	destring gvkey, replace
	gsort gvkey fyear
	
	// 최초 2년의 데이터는 분석에 사용하지 않음, SS 변수 생성 (2)
		// 필요 변수 생성
		gsort gvkey fyear
		gen level =.
		gen level_temp =.
		gen trend =.
		gen trend_temp=.
		gen sales_forecast =.
		
		// 기업별 연도 순서
		by gvkey (fyear): gen obs = _n
		
		// 초기값 설정
		by gvkey (fyear): replace level = sale if obs == 1
		by gvkey (fyear): replace trend = sale[_n+1] - sale[_n] if obs == 1
		
		// for loop 돌면서 2번째 연도부터 갱신
		quietly{
			forvalues i = 2/20 {
				count if obs == `i'
				if r(N) == 0 continue, break
				
				by gvkey (fyear): replace level_temp = 0.75 * sale + 0.25 * (level[_n-1] + trend[_n-1]) if obs == `i'
				by gvkey (fyear): replace trend_temp = 0.75 * (level_temp - level[_n-1]) + 0.25 * trend[_n-1] if obs == `i'
				by gvkey (fyear): replace sales_forecast = level[_n-1] + trend[_n-1] if obs == `i'
				
				replace level = level_temp if obs == `i' & !missing(level_temp)
				replace trend = trend_temp if obs == `i' & !missing(trend_temp)
			}
		}
		// 매출 서프라이즈 (Sale Surprise, SS) 생성, sales_forecast <= 0 인 경우 drop
		drop if sales_forecast <= 0
		gen SS = sale/sales_forecast
		gen log_SS = log(SS)
		
		// 정리 및 첫 2해 삭제 (1,062 rows deleted)
		drop if obs <= 2
		drop level trend level_temp trend_temp obs
	
	// 5년 연속 데이터가 존재하지 않는 회사는 분석에 사용하지 않음 (3)
		// 같은 기업 내에서 연속하는지 확인하는 더미 변수 생성
		gen consec = (fyear == fyear[_n-1] + 1 & gvkey == gvkey[_n-1])
		
		// 연속하는 times 계산
		gen times = 1
		by gvkey(fyear): replace times = times[_n-1] + 1 if consec == 1
		
		// 기업별 최대 연속 연도 수 계산
		egen max_times = max(times), by (gvkey)
		
		// 5년 연속 회계 기록 데이터가 존재하지 않는 기업 삭제 (427 rows deleted)
		keep if max_times >= 5
		
		// 정리
		drop consec times max_times
	
	// 회계년도가 1년 이상 끊어져 있다면 분석에 사용하지 않음 (4)
		// 필요 변수 생성
		gsort gvkey fyear
		gen gap =.
		
		// 기업별 관측치가 연속 되는지 확인, 연속되면 1 첫 해는 결측이므로 채워주고
		by gvkey (fyear): replace gap = fyear - fyear[_n-1]
		by gvkey (fyear): replace gap = 1 if _n == 1
		
		// gap이 1이 아닌 경우 즉, 연속하지 않은 경우 flag
		gen gap_flag = (gap != 1)
		
		// 기업별 gap이 있었는지 확인
		by gvkey (fyear): egen gap_firm = max(gap_flag)
		
		// gap_firm = 1인 기업 삭제 즉, 회계가 끊긴 기업 제거 (61 rows deleted)
		drop if gap_firm == 1
		
		// 정리 및 저장 (2,577 rows)
		drop gap gap_flag gap_firm
		describe
		save "1985_cleaned_all.dta", replace
		
//============================================================================//	
// 2001 ~ 2015 data set
	use "2001_cleaned_var.dta", clear
	destring gvkey, replace
	gsort gvkey fyear
	
	// 최초 2년의 데이터는 분석에 사용하지 않음, SS 변수 생성 (2)
		// 필요 변수 생성
		gsort gvkey fyear
		gen level =.
		gen level_temp =.
		gen trend =.
		gen trend_temp=.
		gen sales_forecast =.
		
		// 기업별 연도 순서
		by gvkey (fyear): gen obs = _n
		
		// 초기값 설정
		by gvkey (fyear): replace level = sale if obs == 1
		by gvkey (fyear): replace trend = sale[_n+1] - sale[_n] if obs == 1
		
		// for loop 돌면서 2번째 연도부터 갱신
		quietly{
			forvalues i = 2/20 {
				count if obs == `i'
				if r(N) == 0 continue, break
				
				by gvkey (fyear): replace level_temp = 0.75 * sale + 0.25 * (level[_n-1] + trend[_n-1]) if obs == `i'
				by gvkey (fyear): replace trend_temp = 0.75 * (level_temp - level[_n-1]) + 0.25 * trend[_n-1] if obs == `i'
				by gvkey (fyear): replace sales_forecast = level[_n-1] + trend[_n-1] if obs == `i'
				
				replace level = level_temp if obs == `i' & !missing(level_temp)
				replace trend = trend_temp if obs == `i' & !missing(trend_temp)
			}
		}
		// 매출 서프라이즈 (Sale Surprise, SS) 생성, sales_forecast <= 0 인 경우 drop
		drop if sales_forecast <= 0
		gen SS = sale/sales_forecast
		gen log_SS = log(SS)
		
		// 정리 및 첫 2해 삭제 (637 rows deleted)
		drop if obs <= 2
		drop level trend level_temp trend_temp obs
	
	// 5년 연속 데이터가 존재하지 않는 회사는 분석에 사용하지 않음 (3)
		// 같은 기업 내에서 연속하는지 확인하는 더미 변수 생성
		gen consec = (fyear == fyear[_n-1] + 1 & gvkey == gvkey[_n-1])
		
		// 연속하는 times 계산
		gen times = 1
		by gvkey(fyear): replace times = times[_n-1] + 1 if consec == 1
		
		// 기업별 최대 연속 연도 수 계산
		egen max_times = max(times), by (gvkey)
		
		// 5년 연속 회계 기록 데이터가 존재하지 않는 기업 삭제 (273 rows deleted)
		keep if max_times >= 5
		
		// 정리
		drop consec times max_times
	
	// 회계년도가 1년 이상 끊어져 있다면 분석에 사용하지 않음 (4)
		// 필요 변수 생성
		gsort gvkey fyear
		gen gap =.
		
		// 기업별 관측치가 연속 되는지 확인, 연속되면 1 첫 해는 결측이므로 채워주고
		by gvkey (fyear): replace gap = fyear - fyear[_n-1]
		by gvkey (fyear): replace gap = 1 if _n == 1
		
		// gap이 1이 아닌 경우 즉, 연속하지 않은 경우 flag
		gen gap_flag = (gap != 1)
		
		// 기업별 gap이 있었는지 확인
		by gvkey (fyear): egen gap_firm = max(gap_flag)
		
		// gap_firm = 1인 기업 삭제 즉, 회계가 끊긴 기업 제거 (68 rows deleted)
		drop if gap_firm == 1
		
		// 정리 및 저장 (1,696 rows)
		drop gap gap_flag gap_firm
		describe
		save "2001_cleaned_all.dta", replace

 /*=============================================================================
 # Replication
 3-a) Table 2, Summary Statistics of the variables for each retail segments
 3-b) Table 4, Model (1):Run OLS for each segments (repeat 10 times)
			   Model (2):Run OLS for entire segments
 3-c) Table 5, Estimates of time-specific fixed effects for Model (2)
 3-d) Figure 2, Plot of time-specific fixed effects for Model (2)
 3-e) Table 6, Time trends in IT, CI and GM estimated using equation
 4) Repeat using data in 2001-2015
 =============================================================================*/		
		
 /*=============================================================================
 3-a) Table 2, Summary Statistics of the variables for each retail segments
 =============================================================================*/
// 1985-2000 data set
use "1985_cleaned_all.dta", clear
	// 회사 수 계산
	preserve
		
	// segment 별로 회사수 더해서 firms 만들고 따로 firms 파일만 저장 후 restore
	keep segment gvkey
	duplicates drop
	gen one = 1
	collapse (sum) firms = one, by(segment)
	save "1985_segment_firm_counts.dta", replace
	restore
		
		// 요약 통계량 계산
	preserve
	gen one = 1
	//관측치, 평균, 중간값, 표준편차 만 구해서 저장
	collapse ///
		(count) obs = one ///
		(mean) mean_sale = sale mean_IT = IT mean_GM = GM mean_CI = CI ///
		(median) med_sale = sale med_IT = IT med_GM = GM med_CI = CI ///
		(sd) sd_IT = IT sd_GM = GM sd_CI = CI, by(segment)	
	// 회사 수 테이블과 병합
	merge 1:1 segment using "1985_segment_firm_counts.dta"
		
	// coefficient of variation 추가
	gen cv_IT = sd_IT / mean_IT
	gen cv_GM = sd_GM / mean_GM
	gen cv_CI = sd_CI / mean_CI
	drop _merge
		
	save "1985_summary_statistics.dta", replace	
	restore
	
	// Total row 추가
	use "1985_summary_statistics.dta", clear
	preserve
	drop segment
	collapse (sum) firms obs (mean) mean_sale mean_IT sd_IT mean_GM sd_GM mean_CI sd_CI med_sale med_IT med_GM med_CI cv_IT cv_GM cv_CI
	gen segment = "Aggregate statistics"
	append using "1985_summary_statistics.dta"
	
	// Aggreate statistics 마지막 줄로
	gen sort_order = cond(segment == "Aggregate statistics", _N +1, _n)
	sort sort_order
	drop sort_order
	
	//표시될 순서 정하고, 소수점 자릿수 설정 및 보여주기 후 restore 
	order segment firms obs mean_sale mean_IT sd_IT mean_GM sd_GM mean_CI sd_CI med_sale med_IT med_GM med_CI cv_IT cv_GM cv_CI
	format mean_sale med_sale %9.1f
	format mean_IT mean_GM mean_CI med_IT med_GM med_CI sd_IT sd_GM sd_CI cv_IT cv_GM cv_CI %4.2f
	list segment firms obs mean_sale mean_IT sd_IT mean_GM sd_GM mean_CI sd_CI med_sale med_IT med_GM med_CI cv_IT cv_GM cv_CI, noobs clean
	restore
	
//============================================================================//	
// 2001-2015 data set
use "2001_cleaned_all.dta", clear
	// 회사 수 계산
	preserve
		
	// segment 별로 회사수 더해서 firms 만들고 따로 firms 파일만 저장 후 restore
	keep segment gvkey
	duplicates drop
	gen one = 1
	collapse (sum) firms = one, by(segment)
	save "2001_segment_firm_counts.dta", replace
	restore
		
		// 요약 통계량 계산
	preserve
	gen one = 1
	//관측치, 평균, 중간값, 표준편차 만 구해서 저장
	collapse ///
		(count) obs = one ///
		(mean) mean_sale = sale mean_IT = IT mean_GM = GM mean_CI = CI ///
		(median) med_sale = sale med_IT = IT med_GM = GM med_CI = CI ///
		(sd) sd_IT = IT sd_GM = GM sd_CI = CI, by(segment)	
	// 회사 수 테이블과 병합
	merge 1:1 segment using "2001_segment_firm_counts.dta"
		
	// coefficient of variation 추가
	gen cv_IT = sd_IT / mean_IT
	gen cv_GM = sd_GM / mean_GM
	gen cv_CI = sd_CI / mean_CI
	drop _merge
		
	save "2001_summary_statistics.dta", replace	
	restore
	
	// Total row 추가
	use "2001_summary_statistics.dta", clear
	preserve
	drop segment
	collapse (sum) firms obs (mean) mean_sale mean_IT sd_IT mean_GM sd_GM mean_CI sd_CI med_sale med_IT med_GM med_CI cv_IT cv_GM cv_CI
	gen segment = "Aggregate statistics"
	append using "2001_summary_statistics.dta"
	
	// Aggreate statistics 마지막 줄로
	gen sort_order = cond(segment == "Aggregate statistics", _N +1, _n)
	sort sort_order
	drop sort_order
	
	//표시될 순서 정하고, 소수점 자릿수 설정 및 보여주기 후 restore 
	order segment firms obs mean_sale mean_IT sd_IT mean_GM sd_GM mean_CI sd_CI med_sale med_IT med_GM med_CI cv_IT cv_GM cv_CI
	format mean_sale med_sale %9.1f
	format mean_IT mean_GM mean_CI med_IT med_GM med_CI sd_IT sd_GM sd_CI cv_IT cv_GM cv_CI %4.2f
	list segment firms obs mean_sale mean_IT sd_IT mean_GM sd_GM mean_CI sd_CI med_sale med_IT med_GM med_CI cv_IT cv_GM cv_CI, noobs clean
	restore

 /*=============================================================================
3-b) Table 4, Model (1):Run OLS for each segments (repeat 10 times)
			  Model (2):Run OLS for entire segments
 =============================================================================*/
 
/// 1985-2000 data set
/// Model 1
use "1985_cleaned_all.dta", clear
	preserve
	
	// 패널셋
	egen firm_id = group(gvkey), label
	xtset firm_id fyear
	
	tempname model_results
	postfile results str50 model str50 segment b_GM se_GM b_CI se_CI b_SS se_SS using `model_results', replace
	
	levelsof segment, local(segments)	
	foreach seg in `segments' {
		xtreg log_IT log_GM log_CI log_SS ib2000.fyear if segment == "`seg'", fe
		post results ("Model1") ("`seg'") ///
		(_b[log_GM]) (_se[log_GM]) ///
		(_b[log_CI]) (_se[log_CI]) ///
		(_b[log_SS]) (_se[log_SS]) 
	}

	/// Model 2
	xtreg log_IT log_GM log_CI log_SS ib2000.fyear, fe
	
	post results ("Model2") ("Pooled coefficients from Model 2") ///
		(_b[log_GM]) (_se[log_GM]) ///
		(_b[log_CI]) (_se[log_CI]) ///
		(_b[log_SS]) (_se[log_SS])
		
	postclose results
	
	/// 결과 확인 및 저장
	use `model_results', clear
	rename (b_GM se_GM b_CI se_CI b_SS se_SS) ///
		(Est_logGM Stderr_logGM Est_logCI Stderr_logCI Est_logSS Stderr_logSS)
	save "model12.dta", replace
	
	use model12, clear
	list segment Est_logGM Stderr_logGM Est_logCI Stderr_logCI Est_logSS Stderr_logSS, ///
		noobs separator(0) abbrev(20)
	restore
	
//============================================================================//

/// 2001-2015 Data set
/// Model 1	
use "2001_cleaned_all.dta", clear
	preserve
	
	// 패널셋
	egen firm_id = group(gvkey), label
	xtset firm_id fyear
	
	tempname model_results
	postfile results str50 model str50 segment b_GM se_GM b_CI se_CI b_SS se_SS using `model_results', replace
	
	levelsof segment, local(segments)	
	foreach seg in `segments' {
		xtreg log_IT log_GM log_CI log_SS ib2000.fyear if segment == "`seg'", fe
		post results ("Model1") ("`seg'") ///
		(_b[log_GM]) (_se[log_GM]) ///
		(_b[log_CI]) (_se[log_CI]) ///
		(_b[log_SS]) (_se[log_SS]) 
	}

	// Model 2
	xtreg log_IT log_GM log_CI log_SS ib2000.fyear, fe
	
	post results ("Model2") ("Pooled coefficients from Model 2") ///
		(_b[log_GM]) (_se[log_GM]) ///
		(_b[log_CI]) (_se[log_CI]) ///
		(_b[log_SS]) (_se[log_SS])
		
	postclose results
	
	/// 결과 확인 및 저장
	use `model_results', clear
	rename (b_GM se_GM b_CI se_CI b_SS se_SS) ///
		(Est_logGM Stderr_logGM Est_logCI Stderr_logCI Est_logSS Stderr_logSS)
	save "model12.dta", replace
	
	use model12, clear
	list segment Est_logGM Stderr_logGM Est_logCI Stderr_logCI Est_logSS Stderr_logSS, ///
		noobs separator(0) abbrev(20)
	restore	
	
	
 /*=============================================================================
3-c) Table 5, Estimates of time-specific fixed effects for Model (2)
 =============================================================================*/	

/// 1985-2000 data set
use "1985_cleaned_all.dta", clear
	egen firm_id = group(gvkey), label

	/// Model 2에 대해서만
	preserve
	reghdfe log_IT log_GM log_CI log_SS ib2000.fyear, absorb(firm_id) vce(cluster firm_id)

	/// 회귀식의 coefficient, standard error만 저장 하여 년도 별로 출력
	parmest, norestore
	list parm estimate stderr if strpos(parm, "year") > 0 
	restore

//============================================================================//

/// 2001-2015 data set
use "2001_cleaned_all.dta", clear
	egen firm_id = group(gvkey), label

	/// Model 2에 대해서만
	preserve
	reghdfe log_IT log_GM log_CI log_SS ib2015.fyear, absorb(firm_id) vce(cluster firm_id)

	/// 회귀식의 coefficient, standard error만 저장 하여 년도 별로 출력
	parmest, norestore
	list parm estimate stderr if strpos(parm, "year") > 0 
	restore
		

/*==============================================================================
 3-d) Figure 2, Plot of time-specific fixed effects for Model (2)
==============================================================================*/
	
/// 1985-2000 data set
use "1985_cleaned_all.dta", clear
	egen firm_id = group(gvkey), label	

	/// 회귀식의 parameter 년도별로  저장	
	preserve
	reghdfe log_IT log_GM log_CI log_SS ib2000.fyear, absorb(firm_id) vce(cluster firm_id)	
	parmest, norestore	
	keep if strpos(parm, ".fyear") >0
	gen year = real(substr(parm, 1, 4))	
		
	/// 논문에서 error bar = +-2*stderr	
	gen minerr = estimate - 2*stderr
	gen maxerr = estimate + 2*stderr

	/// 결과 
	twoway (rcap minerr maxerr year, lpattern(line)) (line estimate year, sort lwidth(medthick)), yline(0, lpattern(dot)) title("Year Fixed Efeects") ytitle("Year Fixed Efeects") xtitle("Year")
	restore
	
//============================================================================//

/// 2001-2015 data set	
use "2001_cleaned_all.dta", clear
	egen firm_id = group(gvkey), label	

	/// 회귀식의 parameter 년도별로  저장	
	preserve
	reghdfe log_IT log_GM log_CI log_SS ib2015.fyear, absorb(firm_id) vce(cluster firm_id)	
	parmest, norestore	
	keep if strpos(parm, ".fyear") >0
	gen year = real(substr(parm, 1, 4))	
		
	/// 논문에서 error bar = +-2*stderr	
	gen minerr = estimate - 2*stderr
	gen maxerr = estimate + 2*stderr

	/// 결과 
	twoway (rcap minerr maxerr year, lpattern(line)) (line estimate year, sort lwidth(medthick)), yline(0, lpattern(dot)) title("Year Fixed Efeects") ytitle("Year Fixed Efeects") xtitle("Year")
	restore	
	
/*==============================================================================
3-e) Table 6, Time trends in IT, CI and GM estimated using equation
==============================================================================*/	

/// 1985-2000 data set
use "1985_cleaned_all.dta", clear
	egen firm_id = group(gvkey), label	

	/// 결과 저장 하기 위한 세팅
	tempname results
	postfile `results' str50 variable double coeff double se double tstat double pval using table6_results.dta, replace
	
	/// 베타(coefficient) 표준편차 (Stderr) t-통계량 p-value 변수별로 저장
	foreach var in IT log_IT CI log_CI GM log_GM {
		areg `var' fyear, absorb(firm_id)
		local b = _b[fyear]
		local s = _se[fyear]
		local t = `b' / `s'
		local p = 2 * ttail(e(df_r), abs(`t'))
		post `results' ("`var'") (`b') (`s') (`t') (`p')
}
	postclose `results'
	preserve

	/// 결과
	use table6_results.dta, clear
	format coeff se %9.6f
	format tstat %5.2f
	format pval %6.4f
	list, sep(0) noobs
	restore
	
//============================================================================//	

/// 2001-2015 data set	
use "2001_cleaned_all.dta", clear
	egen firm_id = group(gvkey), label	
	
	/// 결과 저장 하기 위한 세팅
	tempname results
	postfile `results' str50 variable double coeff double se double tstat double pval using table6_results.dta, replace
	
	/// 베타(coefficient) 표준편차 (Stderr) t-통계량 p-value 변수별로 저장
	foreach var in IT log_IT CI log_CI GM log_GM {
		areg `var' fyear, absorb(firm_id)
		local b = _b[fyear]
		local s = _se[fyear]
		local t = `b' / `s'
		local p = 2 * ttail(e(df_r), abs(`t'))
		post `results' ("`var'") (`b') (`s') (`t') (`p')
}
	postclose `results'
	preserve

	/// 결과
	use table6_results.dta, clear
	format coeff se %9.6f
	format tstat %5.2f
	format pval %6.4f
	list, sep(0) noobs
	restore	
	
	

