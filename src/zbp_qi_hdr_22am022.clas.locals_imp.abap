CLASS lhc_QIHeader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations
      FOR QIHeader RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations
      FOR QIHeader RESULT result.
    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE QIHeader.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE QIHeader.
    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE QIHeader.
    METHODS read FOR READ
      IMPORTING keys FOR READ QIHeader RESULT result.
    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK QIHeader.
    METHODS rba_Qiitem FOR READ
      IMPORTING keys_rba FOR READ QIHeader\_Qiitem
      FULL result_requested RESULT result LINK association_links.
    METHODS cba_Qiitem FOR MODIFY
      IMPORTING entities_cba FOR CREATE QIHeader\_Qiitem.
ENDCLASS.

CLASS lhc_QIHeader IMPLEMENTATION.
  METHOD get_instance_authorizations. ENDMETHOD.
  METHOD get_global_authorizations.   ENDMETHOD.
  METHOD lock.                        ENDMETHOD.

  METHOD create.
    DATA: ls_qi_hdr TYPE zqi_head_22am022.
    LOOP AT entities INTO DATA(ls_entity).
      ls_qi_hdr = CORRESPONDING #( ls_entity MAPPING FROM ENTITY ).
      IF ls_qi_hdr-inspectionlot IS NOT INITIAL.
        SELECT SINGLE FROM zqi_head_22am022 FIELDS inspectionlot
          WHERE inspectionlot = @ls_qi_hdr-inspectionlot
          INTO @DATA(lv_exists).
        IF sy-subrc NE 0.
          DATA(lo_util) = zcl_qi_util_22am022=>get_instance( ).
          lo_util->set_hdr_value(
            EXPORTING im_qi_hdr  = ls_qi_hdr
            IMPORTING ex_created = DATA(lv_created) ).
          IF lv_created = abap_true.
            APPEND VALUE #(
              %cid         = ls_entity-%cid
              inspectionlot = ls_qi_hdr-inspectionlot
              %msg = new_message( id = 'ZCIT_QI_MSG_22AM022'
                                  number = '001'
                                  v1 = 'Inspection Lot created successfully'
                                  severity = if_abap_behv_message=>severity-success )
            ) TO reported-qiheader.
            APPEND VALUE #(
              %cid         = ls_entity-%cid
              inspectionlot = ls_qi_hdr-inspectionlot
            ) TO mapped-qiheader.
          ENDIF.
        ELSE.
          APPEND VALUE #(
            %cid         = ls_entity-%cid
            inspectionlot = ls_qi_hdr-inspectionlot
            %msg = new_message( id = 'ZCIT_QI_MSG_22AM022'
                                number = '002'
                                v1 = 'Duplicate Inspection Lot'
                                severity = if_abap_behv_message=>severity-error )
          ) TO reported-qiheader.
          APPEND VALUE #(
            %cid = ls_entity-%cid inspectionlot = ls_qi_hdr-inspectionlot
          ) TO failed-qiheader.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA: ls_qi_hdr TYPE zqi_head_22am022.
    LOOP AT entities INTO DATA(ls_entity).
      ls_qi_hdr = CORRESPONDING #( ls_entity MAPPING FROM ENTITY ).
      IF ls_qi_hdr-inspectionlot IS NOT INITIAL.
        SELECT SINGLE FROM zqi_head_22am022 FIELDS inspectionlot
          WHERE inspectionlot = @ls_qi_hdr-inspectionlot
          INTO @DATA(lv_exists).
        IF sy-subrc EQ 0.
          DATA(lo_util) = zcl_qi_util_22am022=>get_instance( ).
          lo_util->set_hdr_value(
            EXPORTING im_qi_hdr  = ls_qi_hdr
            IMPORTING ex_created = DATA(lv_created) ).
          IF lv_created = abap_true.
            APPEND VALUE #( inspectionlot = ls_qi_hdr-inspectionlot ) TO mapped-qiheader.
            APPEND VALUE #( %key = ls_entity-%key
              %msg = new_message( id = 'ZCIT_QI_MSG_22AM022' number = '001'
                v1 = 'Inspection Lot updated successfully'
                severity = if_abap_behv_message=>severity-success )
            ) TO reported-qiheader.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid = ls_entity-%cid_ref
            inspectionlot = ls_qi_hdr-inspectionlot
            %msg = new_message( id = 'ZCIT_QI_MSG_22AM022' number = '003'
              v1 = 'Inspection Lot not found'
              severity = if_abap_behv_message=>severity-error )
          ) TO reported-qiheader.
          APPEND VALUE #( %cid = ls_entity-%cid_ref
            inspectionlot = ls_qi_hdr-inspectionlot ) TO failed-qiheader.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA(lo_util) = zcl_qi_util_22am022=>get_instance( ).
    LOOP AT keys INTO DATA(ls_key).
      lo_util->set_hdr_deletion(
        im_hdr_key = VALUE #( inspectionlot = ls_key-inspectionlot ) ).
      lo_util->set_hdr_delete_flag( im_flag = abap_true ).
      APPEND VALUE #(
        %cid = ls_key-%cid_ref inspectionlot = ls_key-inspectionlot
        %msg = new_message( id = 'ZCIT_QI_MSG_22AM022' number = '001'
          v1 = 'Inspection Lot deleted'
          severity = if_abap_behv_message=>severity-success )
      ) TO reported-qiheader.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE FROM zqi_head_22am022 FIELDS *
        WHERE inspectionlot = @ls_key-inspectionlot
        INTO @DATA(ls_hdr).
      IF sy-subrc = 0.
        APPEND CORRESPONDING #( ls_hdr ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD rba_Qiitem.
    LOOP AT keys_rba INTO DATA(ls_key).
      SELECT FROM zqi_item_22am022 FIELDS *
        WHERE inspectionlot = @ls_key-inspectionlot
        INTO TABLE @DATA(lt_items).
      LOOP AT lt_items INTO DATA(ls_item).
        APPEND CORRESPONDING #( ls_item ) TO result.
        APPEND VALUE #(
          source-inspectionlot   = ls_key-inspectionlot
          target-inspectionlot   = ls_item-inspectionlot
          target-itemno          = ls_item-itemno
        ) TO association_links.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD cba_Qiitem.
    DATA ls_qi_itm TYPE zqi_item_22am022.
    LOOP AT entities_cba INTO DATA(ls_cba).
      ls_qi_itm = CORRESPONDING #( ls_cba-%target[ 1 ] ).
      IF ls_qi_itm-inspectionlot IS NOT INITIAL
        AND ls_qi_itm-itemno     IS NOT INITIAL.
        SELECT SINGLE FROM zqi_item_22am022 FIELDS itemno
          WHERE inspectionlot = @ls_qi_itm-inspectionlot
          AND   itemno        = @ls_qi_itm-itemno
          INTO @DATA(lv_itmchk).
        IF sy-subrc NE 0.
          DATA(lo_util) = zcl_qi_util_22am022=>get_instance( ).
          lo_util->set_itm_value(
            EXPORTING im_qi_itm  = ls_qi_itm
            IMPORTING ex_created = DATA(lv_created) ).
          IF lv_created = abap_true.
            APPEND VALUE #(
              %cid         = ls_cba-%target[ 1 ]-%cid
              inspectionlot = ls_qi_itm-inspectionlot
              itemno        = ls_qi_itm-itemno
            ) TO mapped-qiitem.
            APPEND VALUE #(
              %cid          = ls_cba-%target[ 1 ]-%cid
              inspectionlot = ls_qi_itm-inspectionlot
              %msg = new_message( id = 'ZCIT_QI_MSG_22AM022' number = '001'
                v1 = 'Inspection Item created'
                severity = if_abap_behv_message=>severity-success )
            ) TO reported-qiitem.
          ENDIF.
        ELSE.
          APPEND VALUE #(
            %cid = ls_cba-%target[ 1 ]-%cid
            inspectionlot = ls_qi_itm-inspectionlot itemno = ls_qi_itm-itemno
          ) TO failed-qiitem.
          APPEND VALUE #(
            %cid = ls_cba-%target[ 1 ]-%cid
            inspectionlot = ls_qi_itm-inspectionlot
            %msg = new_message( id = 'ZCIT_QI_MSG_22AM022' number = '002'
              v1 = 'Duplicate Item Number'
              severity = if_abap_behv_message=>severity-error )
          ) TO reported-qiitem.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
