CLASS lhc_QIItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE QIItem.
    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE QIItem.
    METHODS read FOR READ
      IMPORTING keys FOR READ QIItem RESULT result.
    METHODS rba_Qiheader FOR READ
      IMPORTING keys_rba FOR READ QIItem\_Qiheader
      FULL result_requested RESULT result LINK association_links.
ENDCLASS.

CLASS lhc_QIItem IMPLEMENTATION.
  METHOD update.
    DATA: ls_qi_itm TYPE zqi_item_22am022.
    LOOP AT entities INTO DATA(ls_entity).
      ls_qi_itm = CORRESPONDING #( ls_entity MAPPING FROM ENTITY ).
      IF ls_qi_itm-inspectionlot IS NOT INITIAL.
        SELECT SINGLE FROM zqi_item_22am022 FIELDS itemno
          WHERE inspectionlot = @ls_qi_itm-inspectionlot
          AND   itemno        = @ls_qi_itm-itemno
          INTO @DATA(lv_chk).
        IF sy-subrc EQ 0.
          DATA(lo_util) = zcl_qi_util_22am022=>get_instance( ).
          lo_util->set_itm_value(
            EXPORTING im_qi_itm  = ls_qi_itm
            IMPORTING ex_created = DATA(lv_created) ).
          IF lv_created = abap_true.
            APPEND VALUE #(
              inspectionlot = ls_qi_itm-inspectionlot
              itemno        = ls_qi_itm-itemno
            ) TO mapped-qiitem.
            APPEND VALUE #( %key = ls_entity-%key
              %msg = new_message( id = 'ZCIT_QI_MSG_22AM022' number = '001'
                v1 = 'Item updated successfully'
                severity = if_abap_behv_message=>severity-success )
            ) TO reported-qiitem.
          ENDIF.
        ELSE.
          APPEND VALUE #(
            %cid = ls_entity-%cid_ref
            inspectionlot = ls_qi_itm-inspectionlot itemno = ls_qi_itm-itemno
            %msg = new_message( id = 'ZCIT_QI_MSG_22AM022' number = '003'
              v1 = 'Item not found'
              severity = if_abap_behv_message=>severity-error )
          ) TO reported-qiitem.
          APPEND VALUE #(
            %cid = ls_entity-%cid_ref
            inspectionlot = ls_qi_itm-inspectionlot itemno = ls_qi_itm-itemno
          ) TO failed-qiitem.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA(lo_util) = zcl_qi_util_22am022=>get_instance( ).
    LOOP AT keys INTO DATA(ls_key).
      lo_util->set_itm_deletion(
        im_itm_key = VALUE #(
          inspectionlot = ls_key-inspectionlot
          itemno        = ls_key-itemno ) ).
      APPEND VALUE #(
        %cid = ls_key-%cid_ref
        inspectionlot = ls_key-inspectionlot itemno = ls_key-itemno
        %msg = new_message( id = 'ZCIT_QI_MSG_22AM022' number = '001'
          v1 = 'Item deleted successfully'
          severity = if_abap_behv_message=>severity-success )
      ) TO reported-qiitem.
    ENDLOOP.
  ENDMETHOD.

  METHOD read. ENDMETHOD.
  METHOD rba_Qiheader. ENDMETHOD.
ENDCLASS.
