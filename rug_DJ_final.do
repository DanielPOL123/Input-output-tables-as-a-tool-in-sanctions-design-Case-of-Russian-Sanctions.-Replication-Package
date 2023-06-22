*********************************************************************************************
***********************************YALE CELI DOFILE******************************************
********************* Paper: Bottlenecks of Russian Economy**********************************
******************* Author: Daniel Jensen University of Warwick ***************************** 
*********************************************************************************************

//Introductory Comments: 
// This is a do-file that is not finished. There are probably some mistakes here. 
//Said that, to make the use of this do file easier I will go through all major specification of  this specific data set. We are using the RUG WIOD Database.  
*Number of countries  = 44 
*Number of industries = 56 
*Russian Industries   = 2017 - 2072

clear all
set matsize 3000
use "rug_2014"
 
gen id = _n
mkmat vAUS* /// 
vAUT* ///
vBEL* ///
vBGR* /// 
vBRA* /// 
vCAN* /// 
vCHE* /// 
vCHN* /// 
vCYP* ///
vCZE* ///
vDEU* ///
vDNK* ///
vESP* /// 
vEST* ///
vFIN* /// 
vFRA* ///
vGBR* ///
vGRC* ///
vHRV* /// 
vHUN* ///
vIDN* ///
vIND* ///
vIRL* ///
vITA* ///
vJPN* ///
vKOR* ///
vLTU* ///
vLUX* /// 
vLVA* /// 
vMEX* /// 
vMLT* /// 
vNLD* /// 
vNOR* ///
vPOL* ///
vPRT* ///
vROU* /// 
vRUS* ///
vSVK* /// 
vSVN* ///
vSWE* ///
vTUR* ///
vTWN* /// 
vUSA* ///
vROW* , matrix(input_matrix)

// Creating Structural Matrix--------------------------------------------------- 
global countries "vAUS vAUT vBEL vBGR vBRA vCAN vCHE vCHN vCYP vCZE vDEU vDNK vESP vEST vFIN vFRA vGBR vGRC vHRV vHUN  vIDN vIND vIRL vITA vJPN vKOR vLTU vLUX vLVA vMEX vMLT vNLD vNOR vPOL vPRT vROU vRUS vSVK vSVN vSWE vTUR vTWN vUSA vROW"

drop if id> 2464 //Drops the totals 
foreach x of global countries {
foreach i of numlist 57/61{
	drop  `x'`i' 
	}
}


//by Country, sort: egen gdp = total(TOT) //Calcualtes the total production by country (GDP) 

preserve 
local column_no = 0 
foreach x of global countries {
display "`x'"
foreach i of numlist 1/56{
local ++column_no
replace  `x'`i' = `x'`i'/TOT[`column_no'] 
replace `x'`i' = 0 if mi(`x'`i')
}
}
drop if id> 2464

mkmat vAUS* /// 
vAUT* ///
vBEL* ///
vBGR* /// 
vBRA* /// 
vCAN* /// 
vCHE* /// 
vCHN* /// 
vCYP* ///
vCZE* ///
vDEU* ///
vDNK* ///
vESP* /// 
vEST* ///
vFIN* /// 
vFRA* ///
vGBR* ///
vGRC* ///
vHRV* /// 
vHUN* ///
vIDN* ///
vIND* ///
vIRL* ///
vITA* ///
vJPN* ///
vKOR* ///
vLTU* ///
vLUX* /// 
vLVA* /// 
vMEX* /// 
vMLT* /// 
vNLD* /// 
vNOR* ///
vPOL* ///
vPRT* ///
vROU* /// 
vRUS* ///
vSVK* /// 
vSVN* ///
vSWE* ///
vTUR* ///
vTWN* /// 
vUSA* ///
vROW* , matrix(structural_matrix)
local dim (`= rowsof(structural_matrix)',`=colsof(structural_matrix)') 
di "`dim'" 
restore

//Calculating Leontieff Matrix--------------------------------------------------
matrix I = I(2464)
matrix IS =  I - structural_matrix
//matrix Leontieff_matrix = inv(IS)


**LOOP FOR ALL RUSSIAN INDUSTRIES***********************************************

forval j = 2017/2072 {
local ind = `j'
local prev_ind = `j'-1
local next_ind = `j'+1
local letter = `j'-2016 
//Calculating the M matrix------------------------------------------------------
matrix define M_prep_matrix = IS

forval i =  1/2464 {
matrix M_prep_matrix[`i',`ind'] = 0
//matrix M_prep_matrix[`ind',`i'] = 0
}

matrix M_prep_matrix[`ind',`ind'] =-1 
matrix M_matrix = inv(M_prep_matrix)

// Calculating the L(n) matrix-------------------------------------------------- 
matrix  L_n_matrix_prep = M_matrix[1..`prev_ind',1...]\M_matrix[`next_ind'...,1...]
matrix  L_n_matrix= L_n_matrix_prep[1...,1..`prev_ind'], L_n_matrix_prep[1...,`next_ind'...]

//Taking the structural vector of the First Russian Sector (Column 2017)--------
matrix a_n_matrix =structural_matrix[1..`prev_ind',`ind']\structural_matrix[`next_ind'...,`ind'] 

//Calculating the results------------------------------------------------------- 
matrix define results_vector = L_n_matrix*a_n_matrix
matrix list results_vector

//Putting the matrix in excel
 
putexcel set rug_output_data, modify

putexcel set rug_out_put, modify
local alphabet  "A C E G I K M O P S U W Y AA AC AE AG AI AK AM AO AP AS AU AW AY BA BC BE BG BI BK BM BO BP BS BU BW BY CA CC CE CG CCI CK CM CO CP CS CU CW CY" 
local Letter : word `letter' of `alphabet'
putexcel `Letter'1 = matrix(results_vector), rownames nformat(Country)
}

/*
local alphabet  "A C E G I K M O Q S U W Y AA AC AE AG AI AK AM AO AQ AS AU AW AY BA BC BE BG BI BK BM BO BQ BS BU BW BY CA CC CE CG CI CK CM CO CQ CS CU CW CY DA DC DE DG DI" 
local Letter : word `letter' of `alphabet'
putexcel `letter'1 = matrix(results_vector), rownames nformat(Country)
mat drop  results_vector L_n_matrix  a_n_matrix M_prep_matrix L_n_matrix_prep
*/
}








**************************************************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************************************************************
exit 
