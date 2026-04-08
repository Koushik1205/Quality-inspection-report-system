@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'QI Header Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZCIT_QI_C_22AM022
  provider contract transactional_query
  as projection on ZCIT_QI_I_22AM022
{
  key InspectionLot,
  Material,
  Plant,
  InspectionDate,
  InspectionType,
  Status,
  @Search.defaultSearchElement: true
  Inspector,
  Remarks,
  @Semantics.amount.currencyCode: 'Currency'
  InspectionCost,
  Currency,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
 
  /* Associations */
  _qiitem : redirected to composition child ZCIT_QI_OC_22AM022
}
