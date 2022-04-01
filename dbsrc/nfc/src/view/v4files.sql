create or replace view nfc.v4files as 
 SELECT main.id,
    main.org_id,
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
     LEFT JOIN nfc.users ref3 ON ref3.id = main.user_id;