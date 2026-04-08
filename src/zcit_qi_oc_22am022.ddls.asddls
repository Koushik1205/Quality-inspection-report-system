@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'QI Item Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZCIT_QI_OC_22AM022
  as projection on ZCIT_QI_O_22AM022
{
  key InspectionLot,
  key Itemno,
  @Search.defaultSearchElement: true
  Characteristic,
  @Semantics.quantity.unitOfMeasure: 'Uom'
  Minvalue,
  @Semantics.quantity.unitOfMeasure: 'Uom'
  Maxvalue,
  @Semantics.quantity.unitOfMeasure: 'Uom'
  Actualvalue,
  Uom,
  Results,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
 
  /* Associations */
  _qiheader : redirected to parent ZCIT_QI_C_22AM022
}
