Set
  LocalCSPCenterSet
  RegionalCSPCenterSet
  DistrictSelected
  LocalMarketSet
  RegionalMarketSet
  RGYSet
  FCIGodownSet
  MillerSet
  RetailerSet
  PDSSet
  FarmType
  ;


$CALL GDXXRW.EXE "../data/data/reference_data.xls"  set=LocalCSPCenterSet rng=LocalCSPCenterSet!A2:A9  Rdim=1   set=RegionalCSPCenterSet rng=RegionalCSPCenterSet!A2:A9  Rdim=1   set=DistrictSelected rng=District!B2:B52  Rdim=1 set=LocalMarketSet rng=local_market!A2:A9  Rdim=1 set=RegionalMarketSet rng=regional_market!A2:A1047  Rdim=1 set=RGYSet rng=RGYSet!A2:A9  Rdim=1 set=FCIGodownSet rng=FCIGodownSet!A2:A9  Rdim=1 set=MillerSet rng=MillerSet!A2:A9  Rdim=1 set=RetailerSet rng=RetailerSet!A2:A9  Rdim=1 set=PDSSet rng=PDSSet!A2:A9  Rdim=1 set=FarmType rng=FarmType!A2:A6  Rdim=1


$GDXIN "reference_data.gdx"
$LOAD  LocalCSPCenterSet, RegionalCSPCenterSet, DistrictSelected, LocalMarketSet, RegionalMarketSet, RGYSet, FCIGodownSet, MillerSet, RetailerSet, PDSSet, FarmType
$GDXIN

Display
  LocalCSPCenterSet
  RegionalCSPCenterSet
  DistrictSelected
  LocalMarketSet
  RegionalMarketSet
  RGYSet
  FCIGodownSet
  MillerSet
  RetailerSet
  PDSSet
  FarmType
  ;
