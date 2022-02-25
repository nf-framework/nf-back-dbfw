create or replace view nfc.v4files as 
 SELECT main.id,
    main.org_id,
    ref2.caption AS org_id_caption,
    ref2.code AS org_id_code,
    main.originalname,
    main.encoding,
    main.mimetype,
    main.filesize,
    main.destination,
    main.filename,
    main.upload_date,
    main.user_id,
    ref3.username AS user_id_username
   FROM nfc.files main
     JOIN nfc.org ref2 ON ref2.id = main.org_id
     LEFT JOIN nfc.users ref3 ON ref3.id = main.user_id;