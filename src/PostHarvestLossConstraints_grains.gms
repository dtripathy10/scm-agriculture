$title "loss calculation in percentage"

Variables
  FarmGate_GrainDelivered "Total grain delivered (purchased) at the farm gate from all possible sources"
  TotalPHLLoss "The total post harvest loss in the supply chain in percentage"

  Miller_Total_Purchase
  Miller_Total_Input
  Retail_Total_Purchase
  Retail_Total_Input
  TPDS_Total_Purchase
  TPDS_Total_Input
  RGY_Total_Purchase
  RGY_Total_Input
  FCI_Total_Purchase
  FCI_Total_Input

  Miller_Transportation_Loss
  Retail_Transportation_Loss
  TPDS_Transportation_Loss 
  RGY_Transportation_Loss 
  FCI_Transportation_Loss 
  Market_Transportation_Loss

  Miller_Storage_Loss
  Retail_Storage_Loss
  TPDS_Storage_Loss 
  RGY_Storage_Loss 
  FCI_Storage_Loss
  LocalCSP_Storage_Loss
  RegionalCSP_Storage_Loss
  ;

Equations
  PHLConstraint1
  PHLConstraint2
  PHLConstraint3 "total loss calculation"
  PHLConstraint4 "maximum total loss constraint"

  PHLConstraint1P "miller total purchase"
  PHLConstraint1I "miller total input"
  PHLConstraint1TL "total transportation loss by miller"
  PHLConstraint1SL "total storage loss by miller"
  PHLConstraint2P "FCI total purchase"
  PHLConstraint2I "FCI total loss"
  PHLConstraint5TL "total transportation loss by FCI"
  PHLConstraint5SL "total storage loss by FCI"
  PHLConstraint3P "RGY total purchase"
  PHLConstraint3I "RGY total loss"
  PHLConstraint4TL "total transportation loss by RGY"
  PHLConstraint4SL "total loss by RGY"

  
*  PHLConstraint2TL "transportation loss by retailer in percentage"
*  PHLConstraint3TL "transportation loss by tpds in percentage"
  
*  PHLConstraint6TL "transportation loss from farmer-storage-market in percentage"

  
*  PHLConstraint2SL "loss by retailer in percentage"
*  PHLConstraint3SL "loss by tpds in percentage"
  
  
*  PHLConstraint6SL "loss by RGY in percentage"
*  PHLConstraint7SL "loss by FCI in percentage"
  ;

PHLConstraint1(HarvestingHorizonAggregation)..
  FarmGate_GrainDelivered(HarvestingHorizonAggregation) =e= 
    sum((DistrictSelected,FarmNumber),
      HarvestFarmGateDirectPurchaseGrain(HarvestingHorizonAggregation,DistrictSelected,FarmNumber)
    )
  ;

PHLConstraint2(NonHarvestingHorizonAggregation)..
  FarmGate_GrainDelivered(NonHarvestingHorizonAggregation) =e= 
    sum((DistrictSelected,FarmNumber),
      HarvestFarmGateDirectPurchaseGrain(NonHarvestingHorizonAggregation,DistrictSelected,FarmNumber)
    )
  ;
**************###########      Miller    ###########*****************************
PHLConstraint1P..
  Miller_Total_Purchase =e= 
    sum((HarvestingHorizonAggregation,MillerSet), 
        MillerPurchase(HarvestingHorizonAggregation,MillerSet) * card(HarvestingHorizonAggregationStep)
      ) +
      sum((NonHarvestingHorizonAggregation,MillerSet), 
        MillerPurchase(NonHarvestingHorizonAggregation,MillerSet) * card(NonHarvestingHorizonAggregationStep)
      )
  ;

PHLConstraint1I..
  Miller_Total_Input =e= 
   sum((HarvestingHorizonAggregation,MillerSet), 
      MillerInput(HarvestingHorizonAggregation,MillerSet) * card(HarvestingHorizonAggregationStep)
    ) +
    sum((NonHarvestingHorizonAggregation,MillerSet),
      MillerInput(NonHarvestingHorizonAggregation,MillerSet) * card(NonHarvestingHorizonAggregationStep)
    )
  ;

PHLConstraint1TL..
  Miller_Transportation_Loss =e=
    Miller_Total_Purchase - Miller_Total_Input
  ;

PHLConstraint1SL..
  Miller_Storage_Loss =e=
    Miller_Total_Input - MillerTotalOutput
  ;
***************************###########  FCI  ###########*******************************************
PHLConstraint2P..
  FCI_Total_Purchase =e=
    sum((HarvestingHorizonAggregation,FCIGodownSet), 
      FCIPurchase(HarvestingHorizonAggregation,FCIGodownSet) * card(HarvestingHorizonAggregationStep)
    ) +
    sum((NonHarvestingHorizonAggregation,FCIGodownSet), 
      FCIPurchase(NonHarvestingHorizonAggregation,FCIGodownSet) * card(NonHarvestingHorizonAggregationStep)
    )
  ;

PHLConstraint2I..
  FCI_Total_Input =e= 
    sum((HarvestingHorizonAggregation,FCIGodownSet), 
      FCIInput(HarvestingHorizonAggregation,FCIGodownSet) * card(HarvestingHorizonAggregationStep)
    ) +
    sum((NonHarvestingHorizonAggregation,FCIGodownSet),
      FCIInput(NonHarvestingHorizonAggregation,FCIGodownSet) * card(NonHarvestingHorizonAggregationStep)
    )
  ;

PHLConstraint5TL..
  FCI_Transportation_Loss =e=
    FCI_Total_Purchase - FCI_Total_Input
  ;

PHLConstraint5SL..
  FCI_Storage_Loss =e=
    FCI_Total_Input - FCITotalOutput
  ;
******************************###########  RGY  ###########***********************************************
PHLConstraint3P..
  RGY_Total_Purchase =e=
    sum((HarvestingHorizonAggregation,RGYSet), 
      RGYPurchase(HarvestingHorizonAggregation,RGYSet) * card(HarvestingHorizonAggregationStep)
    ) +
    sum((NonHarvestingHorizonAggregation,RGYSet), 
      RGYPurchase(NonHarvestingHorizonAggregation,RGYSet) * card(NonHarvestingHorizonAggregationStep)
    )
  ;

PHLConstraint3I..
  RGY_Total_Input =e= 
    sum((HarvestingHorizonAggregation,RGYSet), 
      RGYInput(HarvestingHorizonAggregation,RGYSet) * card(HarvestingHorizonAggregationStep)
    ) +
    sum((NonHarvestingHorizonAggregation,RGYSet),
      RGYInput(NonHarvestingHorizonAggregation,RGYSet) * card(NonHarvestingHorizonAggregationStep)
    )
  ;

PHLConstraint4TL..
  RGY_Transportation_Loss =e=
    RGY_Total_Purchase - RGY_Total_Input
  ;

PHLConstraint4SL..
  RGY_Storage_Loss =e=
    RGY_Total_Input - RGYTotalOutput
  ;
$Ontext
PHLConstraint2TL..
  Retail_Transportation_Loss =e=
    ((
        sum((HarvestingHorizonAggregation,RetailSet), 
          RetailPurchase(HarvestingHorizonAggregation,RetailSet) * card(HarvestingHorizonAggregationStep)
        ) +
        sum((NonHarvestingHorizonAggregation,RetailSet), 
          RetailPurchase(NonHarvestingHorizonAggregation,RetailSet) * card(NonHarvestingHorizonAggregationStep)
        ) -
        sum((HarvestingHorizonAggregation,RetailSet), 
          RetailInput(HarvestingHorizonAggregation,RetailSet) * card(HarvestingHorizonAggregationStep)
        ) +
        sum((NonHarvestingHorizonAggregation,RetailSet),
          RetailInput(NonHarvestingHorizonAggregation,RetailSet) * card(NonHarvestingHorizonAggregationStep)
        )
    ) /
    (
      sum((HarvestingHorizonAggregation,RetailSet), 
        RetailPurchase(HarvestingHorizonAggregation,RetailSet) * card(HarvestingHorizonAggregationStep)
      ) +
      sum((NonHarvestingHorizonAggregation,RetailSet), 
        RetailPurchase(NonHarvestingHorizonAggregation,RetailSet) * card(NonHarvestingHorizonAggregationStep)
      ) 
    ))*100
  ;

PHLConstraint3TL..
  TPDS_Transportation_Loss =e=
    ((
        sum((HarvestingHorizonAggregation,TPDSSet), 
          TPDSPurchase(HarvestingHorizonAggregation,TPDSSet) * card(HarvestingHorizonAggregationStep)
        ) +
        sum((NonHarvestingHorizonAggregation,TPDSSet), 
          TPDSPurchase(NonHarvestingHorizonAggregation,TPDSSet) * card(NonHarvestingHorizonAggregationStep)
        ) -
        sum((HarvestingHorizonAggregation,TPDSSet), 
          TPDSInput(HarvestingHorizonAggregation,TPDSSet) * card(HarvestingHorizonAggregationStep)
        ) +
        sum((NonHarvestingHorizonAggregation,TPDSSet),
          TPDSInput(NonHarvestingHorizonAggregation,TPDSSet) * card(NonHarvestingHorizonAggregationStep)
        )
    ) /
    (
      sum((HarvestingHorizonAggregation,TPDSSet), 
        TPDSPurchase(HarvestingHorizonAggregation,TPDSSet) * card(HarvestingHorizonAggregationStep)
      ) +
      sum((NonHarvestingHorizonAggregation,TPDSSet), 
        TPDSPurchase(NonHarvestingHorizonAggregation,TPDSSet) * card(NonHarvestingHorizonAggregationStep)
      ) 
    ))*100
  ;




PHLConstraint6TL..      
  Market_Transportation_Loss  =e=
    ( 
      Par_FarmGateTotalGrain -  ( 
        sum(HarvestingHorizonAggregation, 
          FarmGate_GrainDelivered(HarvestingHorizonAggregation) * card(HarvestingHorizonAggregationStep)
        ) +
        sum(NonHarvestingHorizonAggregation, 
          FarmGate_GrainDelivered(NonHarvestingHorizonAggregation) * card(NonHarvestingHorizonAggregationStep)
        ) + 
        sum((HarvestingHorizonAggregation,LocalMarketSet), 
          LocalMarketTotalGrain(HarvestingHorizonAggregation,LocalMarketSet) * card(HarvestingHorizonAggregationStep)
        ) +
        sum((NonHarvestingHorizonAggregation,LocalMarketSet), 
          LocalMarketTotalGrain(NonHarvestingHorizonAggregation,LocalMarketSet) * card(NonHarvestingHorizonAggregationStep)
        ) +
        sum((HarvestingHorizonAggregation,RegionalMarketSet), 
          RegionalMarketTotalGrain(HarvestingHorizonAggregation,RegionalMarketSet)*card(HarvestingHorizonAggregationStep)
        )
        +
        sum((NonHarvestingHorizonAggregation,RegionalMarketSet), 
          RegionalMarketTotalGrain(NonHarvestingHorizonAggregation,RegionalMarketSet)*card(NonHarvestingHorizonAggregationStep)
        )
      ) / Par_FarmGateTotalGrain
    ) * 100
    ;
$offtext

$Ontext
PHLConstraint2SL..
  Retail_Storage_Loss =e=
    ((sum((HarvestingHorizonAggregation,RetailSet), 
      RetailInput(HarvestingHorizonAggregation,RetailSet) * card(HarvestingHorizonAggregationStep)
    ) +
    sum((NonHarvestingHorizonAggregation,RetailSet), 
      RetailInput(NonHarvestingHorizonAggregation,RetailSet) * card(NonHarvestingHorizonAggregationStep)
    ) -
    RetailTotalOutput)/
    (sum((HarvestingHorizonAggregation,RetailSet), 
      RetailInput(HarvestingHorizonAggregation,RetailSet) * card(HarvestingHorizonAggregationStep)
    ) +
    sum((NonHarvestingHorizonAggregation,RetailSet), 
      RetailInput(NonHarvestingHorizonAggregation,RetailSet) * card(NonHarvestingHorizonAggregationStep)
    ))*100
  ;

PHLConstraint3SL..
  TPDS_Storage_Loss =e=
    ((sum((HarvestingHorizonAggregation,TPDSSet), 
      TPDSInput(HarvestingHorizonAggregation,TPDSSet) * card(HarvestingHorizonAggregationStep)
    ) +
    sum((NonHarvestingHorizonAggregation,TPDSSet), 
      TPDSInput(NonHarvestingHorizonAggregation,TPDSSet) * card(NonHarvestingHorizonAggregationStep)
    ) -
    TPDSTotalOutput)/
    (sum((HarvestingHorizonAggregation,TPDSSet), 
      TPDSInput(HarvestingHorizonAggregation,TPDSSet) * card(HarvestingHorizonAggregationStep)
    ) +
    sum((NonHarvestingHorizonAggregation,TPDSSet), 
      TPDSInput(NonHarvestingHorizonAggregation,TPDSSet) * card(NonHarvestingHorizonAggregationStep)
    ))*100
  ;

PHLConstraint6SL..
  LocalCSP_Storage_Loss =e=
    (sum((HarvestingHorizonAggregation,LocalCSPCenterSet), 
      LocalCSPInput(HarvestingHorizonAggregation,LocalCSPCenterSet) * card(HarvestingHorizonAggregationStep)
    ) +
    sum((NonHarvestingHorizonAggregation,LocalCSPCenterSet), 
      LocalCSPInput(NonHarvestingHorizonAggregation,LocalCSPCenterSet) * card(NonHarvestingHorizonAggregationStep)
    ) -
    LocalCSPTotalOutput)/
    (sum((HarvestingHorizonAggregation,LocalCSPCenterSet), 
      LocalCSPInput(HarvestingHorizonAggregation,LocalCSPCenterSet) * card(HarvestingHorizonAggregationStep)
    ) +
    sum((NonHarvestingHorizonAggregation,LocalCSPCenterSet), 
      LocalCSPInput(NonHarvestingHorizonAggregation,LocalCSPCenterSet) * card(NonHarvestingHorizonAggregationStep)
    ))*100
  ;

PHLConstraint7SL..
  RegionalCSP_Storage_Loss =e=
    (sum((HarvestingHorizonAggregation,RegionalCSPCenterSet), 
      RegionalCSPInput(HarvestingHorizonAggregation,RegionalCSPCenterSet) * card(HarvestingHorizonAggregationStep)
    ) +
    sum((NonHarvestingHorizonAggregation,RegionalCSPCenterSet), 
      RegionalCSPInput(NonHarvestingHorizonAggregation,RegionalCSPCenterSet) * card(NonHarvestingHorizonAggregationStep)
    ) -
    RegionalCSPTotalOutput)/
    (sum((HarvestingHorizonAggregation,RegionalCSPCenterSet), 
      RegionalCSPInput(HarvestingHorizonAggregation,RegionalCSPCenterSet) * card(HarvestingHorizonAggregationStep)
    ) +
    sum((NonHarvestingHorizonAggregation,RegionalCSPCenterSet), 
      RegionalCSPInput(NonHarvestingHorizonAggregation,RegionalCSPCenterSet) * card(NonHarvestingHorizonAggregationStep)
    ))*100
  ;
$offtext

PHLConstraint3..    
  TotalPHLLoss =e= Miller_Transportation_Loss +  Miller_Storage_Loss + FCI_Transportation_Loss + 
    FCI_Storage_Loss + RGY_Transportation_Loss + RGY_Storage_Loss
  ;

PHLConstraint4.. 
  TotalPHLLoss 
  =l=
  (3.5 * Par_FarmGateTotalGrain)/100          
  ;

Model PHLConstraints /
  PHLConstraint1
  PHLConstraint2
  PHLConstraint3
  PHLConstraint4

  PHLConstraint1P
  PHLConstraint1I
  PHLConstraint1TL
  PHLConstraint1SL
  PHLConstraint2P
  PHLConstraint2I
  PHLConstraint5TL
  PHLConstraint5SL
  PHLConstraint3P
  PHLConstraint3I
  PHLConstraint4TL
  PHLConstraint4SL
  /;
