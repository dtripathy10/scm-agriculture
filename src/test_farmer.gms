* RegionalMarketSet is global
* RegionalMarketSetConnected has one additional tag district

Set
  DistrictSelected  /1/
  RegionalMarketSet   /1*10/
  FarmSizeClassificationType  /type1,type2,type3,type4,type5/
  FarmSizeClassificationSet   /areaType,farmType,percentage,minimumArea,maximumArea/
  FarmType   /Marginal,Small,Semi_Medium,Medium,Large/

  LocalCSPCenterSet   /1*15/
  RegionalCSPCenterSet   /1*15/
  LocalMarketSet   /1*15/
  RGYSet     /1*5/
  FCIGodownSet   /1*10/
  MillerSet    /1*15/
  RetailerSet  /1*15/
  PDSSet      /1*15/
  ;

Set Capacity_Set /Capacity/;

set connectselected(DistrictSelected,RegionalMarketSet)
  /
    1.(1*10)
  /
  ;

Display connectselected;

Parameter
  DistrictArea(DistrictSelected) "District size in hectre" / 1 350 /
  DistrictFarmer(DistrictSelected) "District farmer size" / 1 3333 /
  RegionalMarketArea(DistrictSelected,RegionalMarketSet)
  RegionalMarketCapacity_Input(RegionalMarketSet,Capacity_Set)
  RegionalMarketCapacity(RegionalMarketSet)
  RegionalMarketFarmer(DistrictSelected,RegionalMarketSet)
  FarmAggregation(FarmType) /  Marginal .01
                               Small .02
                               Semi_Medium .1
                               Medium .01
                               Large .03
                            /

  ;


* read regional market capacity
$CALL GDXXRW.EXE "../data/regional_market.xls" par=RegionalMarketCapacity_Input rng=regionalMarketCapacity!B1:C11

$GDXIN "regional_market.gdx"
$LOAD  RegionalMarketCapacity_Input
$GDXIN

RegionalMarketCapacity(RegionalMarketSet) = RegionalMarketCapacity_Input(RegionalMarketSet,'Capacity');

Display RegionalMarketCapacity;


* read the area data for each district

Display DistrictArea;

$Ontext
Area      Farm_Type        Percentage        Minimum_Area     Maximum_Area
<1        Marginal         43.85             0.5              0.99
1-2       Small            27.6              1                1.99
2-4       Semi-Medium      18.65             2                3.99
4-10      Medium           8.89              4                9.99
>10       Large            1                10                20
$offtext

* Assumption: data is for state wise, but we use this data for each district wise distribution
Table FarmSizeClassification(FarmSizeClassificationType,FarmSizeClassificationSet) "Farm size Classification..."
         areaType      farmType          percentage        minimumArea        maximumArea
 type1       1             1                 43.85             0.5                0.99
 type2       2             2                 27.6              1                  1.99
 type3       3             3                 18.65             2                  3.99
 type4       4             4                 8.89              4                  9.99
 type5       5             5                 1                 10                 20 ;

Display FarmSizeClassification;

Parameter
 TotalRegionalMarketCapacity(DistrictSelected)
;

TotalRegionalMarketCapacity(DistrictSelected) = 0


* total regional market size of district
loop(DistrictSelected,
  loop(RegionalMarketSet,
         TotalRegionalMarketCapacity(DistrictSelected) = TotalRegionalMarketCapacity(DistrictSelected)+ RegionalMarketCapacity(RegionalMarketSet)
  )
);

Display TotalRegionalMarketCapacity;

loop(DistrictSelected,
      RegionalMarketArea(DistrictSelected,RegionalMarketSet) = DistrictArea(DistrictSelected) *
         (RegionalMarketCapacity(RegionalMarketSet)/ TotalRegionalMarketCapacity(DistrictSelected));

      RegionalMarketFarmer(DistrictSelected,RegionalMarketSet) =   ceil(DistrictFarmer(DistrictSelected) *
         (RegionalMarketCapacity(RegionalMarketSet)/ TotalRegionalMarketCapacity(DistrictSelected)));
);

Display RegionalMarketArea;

Display RegionalMarketFarmer;

Display FarmAggregation;


Set
     FarmNumber /1*3333/

;

Display FarmNumber;

Parameter
 FarmPercentage(FarmType) /Marginal .4385
                            Small  .276
                            Semi_Medium .1865
                            Medium .889
                            Large .001
                           /
 FarmerByType(RegionalMarketSet,FarmType)
 FarmerByTypeAggr(RegionalMarketSet,FarmType)
;

loop(DistrictSelected,
 loop(RegionalMarketSet,
         loop(FarmType,
                 FarmerByType(RegionalMarketSet,FarmType) =  ceil(RegionalMarketFarmer(DistrictSelected,RegionalMarketSet) * FarmPercentage(FarmType));
                 FarmerByTypeAggr(RegionalMarketSet,FarmType) =  ceil(FarmerByType(RegionalMarketSet,FarmType) * FarmAggregation(FarmType) );
         )
 )
);

Display FarmerByType;
Display FarmerByTypeAggr;


Parameter
    AggrgateFarmSize
;

AggrgateFarmSize   = sum((RegionalMarketSet,FarmType),FarmerByTypeAggr(RegionalMarketSet,FarmType));

Display AggrgateFarmSize;

Set
         AggrFarmNumber(FarmNumber)
;

AggrFarmNumber(FarmNumber)  = no;
AggrFarmNumber(FarmNumber)  = yes $(ord(FarmNumber) le AggrgateFarmSize);


Display AggrFarmNumber;


Parameter
 FarmSize(DistrictSelected,FarmNumber)
 GrainProduction(DistrictSelected,FarmNumber)
 GrainAvailable(DistrictSelected,FarmNumber)
;

Scalar counter;
Scalar tempCounter;
Scalar i;


counter = 1;

loop(DistrictSelected,
         loop(RegionalMarketSet,
                 loop(FarmType,
                      tempCounter = FarmerByTypeAggr(RegionalMarketSet,FarmType);
                      i = 1;
                      while((i <= tempCounter) ,
                        FarmSize(DistrictSelected,FarmNumber)$(ord(FarmNumber) eq counter) =   0.1;
                        GrainProduction(DistrictSelected,FarmNumber)$(ord(FarmNumber) eq counter) =   0.2;
                        GrainAvailable(DistrictSelected,FarmNumber)$(ord(FarmNumber) eq counter) =   0.3;
                        counter = counter + 1;
                        i = i + 1;
                      )
                 )
         )
);

Display FarmSize, GrainProduction,GrainAvailable ;