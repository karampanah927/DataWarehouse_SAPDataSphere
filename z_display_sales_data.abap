REPORT z_display_sales_data.

" Internal tables for fact and dimensions
DATA: lt_fact_umsatz   TYPE TABLE OF fact_umsatz,
      lt_dim_kunden    TYPE TABLE OF dim_kunden,
      lt_dim_time      TYPE TABLE OF dim_time,
      lt_dim_geo       TYPE TABLE OF dim_geo,
      lt_dim_produkt   TYPE TABLE OF dim_produkt.

" Work area for joining and display
DATA: ls_fact_umsatz   TYPE fact_umsatz,
      ls_dim_kunden    TYPE dim_kunden,
      ls_dim_time      TYPE dim_time,
      ls_dim_geo       TYPE dim_geo,
      ls_dim_produkt   TYPE dim_produkt.

START-OF-SELECTION.

  " Fetch data from FACT_UMSATZ table (only top 10 records for demo)
  SELECT * 
    FROM fact_umsatz
    INTO TABLE lt_fact_umsatz
    UP TO 10 ROWS.

  " Check if FACT_UMSATZ has data
  IF lt_fact_umsatz IS INITIAL.
    WRITE: / 'No sales data found in FACT_UMSATZ table.'.
    RETURN.
  ENDIF.

  " Fetch dimension data
  SELECT * FROM dim_kunden INTO TABLE lt_dim_kunden.
  SELECT * FROM dim_time INTO TABLE lt_dim_time.
  SELECT * FROM dim_geo INTO TABLE lt_dim_geo.
  SELECT * FROM dim_produkt INTO TABLE lt_dim_produkt.

  " Display sales data with dimension information
  WRITE: / 'Displaying Sales Data with Dimension Details:', /.

  LOOP AT lt_fact_umsatz INTO ls_fact_umsatz.
    " Get relevant dimension details
    READ TABLE lt_dim_kunden INTO ls_dim_kunden WITH KEY kunden_id = ls_fact_umsatz-kunden_id.
    READ TABLE lt_dim_time INTO ls_dim_time WITH KEY time_id = ls_fact_umsatz-time_id.
    READ TABLE lt_dim_geo INTO ls_dim_geo WITH KEY geo_id = ls_fact_umsatz-geo_id.
    READ TABLE lt_dim_produkt INTO ls_dim_produkt WITH KEY produkt_id = ls_fact_umsatz-produkt_id.

    " Display data
    WRITE: / 'Customer:', ls_dim_kunden-kunden_name,
           'Product:', ls_dim_produkt-produkt_name,
           'Region:', ls_dim_geo-geo_name,
           'Date:', ls_dim_time-time_date,
           'Sales Amount:', ls_fact_umsatz-umsatz.
  ENDLOOP.
