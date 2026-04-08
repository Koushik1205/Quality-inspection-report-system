@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Interface View - QI Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCIT_QI_I_22AM022
  as select from zqi_head_22am022 as QIHeader
  composition [0..*] of ZCIT_QI_O_22AM022 as _qiitem
{
  key inspectionlot         as InspectionLot,
  material                  as Material,
  plant                     as Plant,
  inspectiondate            as InspectionDate,
  inspectiontype            as InspectionType,
  status                    as Status,
  inspector                 as Inspector,
  remarks                   as Remarks,
  @Semantics.amount.currencyCode: 'Currency'
  inspectioncost            as InspectionCost,
  currency                  as Currency,
  @Semantics.user.createdBy: true
  local_created_by          as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at          as LocalCreatedAt,
  @Semantics.user.lastChangedBy: true
  local_last_changed_by     as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at     as LocalLastChangedAt,
 
  /* Associations */
  _qiitem
}
