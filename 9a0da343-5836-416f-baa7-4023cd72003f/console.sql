UPDATE mt_company
set company_name = 'OBA CLONE 01/12'
WHERE company_code = 'OSPL001';
select company_code, company_name, *
from mt_company;

update global_config
set property_value = 'N'
where property_name = 'enableSendEmail';
update global_config
set property_value = ''
where property_name = 'mailpassword';
update global_config
set property_value = 1
where property_name = 'mailport';
update global_config
set property_value = 'smtp.office.com'
where property_name = 'mailhost';

select *
from global_config
where property_name like '%mail%';

update mt_employee_glbl
set email_address = 'lavie.pham@synergixtech.com'
where employee_code is not null;

select email_address
from mt_employee_glbl;

update mt_user
set encrypted_private_key = '3YvrqVsWpTUtoVGGvLoWPumY+qCRXCDiNbX/0D/CcTG+mR4BfILw+CjMZwKwA0fGQd0ieojh+deFpwMGgLgjsRTnWP2WQ4e5d0iIEvCrlMSWRYGoDa8woKUaaB3sPYZIuSpiZWrpeLxL/MdCHKZcDuZf9iw6Vejfe1kmCTLe0qmmMIyPeLebzQ5MQHM6PVrUjG9mmV2ilZ+btl1fimhSrxganf7RrH4skEggUYKiKMkGEaBxu3swUCns4m64exK1VwvAz7aVbVtVhP05q3/ImUnNmN3iFsfFROAzUoOWn2ODekI3bBuRYdOuzgxRqwJwRsto/l5k8yZRokXMuJxFCx8DWIKKd86Qs8xSHBHQZfn+5uhdWnnMvpUn3nBLJF7DSwjo8211B0hf9AMxWAvYJsYbgOnBNtx50Tts7/RBfgUpXVcMgSDNmdUk9miuwqCy7iU0Nlsn1oN7PDYR1/i9Qwb258WauUHp1NKBZ2JWMmQSqpaenT9Kkxneva5SEpz7geSz2f2OeLdw3f613EczoaVBKQ2CN1eIFiyQ1swBhHvK68DnvsPRLqyPbL867LzBcwm1LME/PD13Xkgr082jADBKY1DNucWb8OYwCiRlN4kh2L4OJpmBg8Qqq5KQm/pVqLYaNuDTGIqfYKJPeEkMhDUjRIPZxdegk1+c0BLbljWDLfMFZ5lyW3kA3h9V02s69ahmiMeRDdpyR9isMG2SaniCMC8MYsQ//fxiGmVrUKmGIlidVsw5fgfguY+4illuFH8X+Ze8Tb8HnyYq2MwCtMwiytDhOjeUODVVhWI+2ezgH08rKJdMsnM/S0aJI1KxCoNeGQwxQlVzdGuhBxLR6VaLBhuBbH17UP844pqSYXggC7svKN1CSaSTmMpkbvM216nFbVyStPGJ5cVrPIUPcVBhOfV9/9bDZUZGfJEH3LzI/wStmrQQ4nmPjfoRZE7RaUJiBcsXPCw5AFD8PbJov/MB8PGP9VmW9/2xoWSuRb0Z6qFLdCSawysJuOJQh9+GhK09fs6WbamBIO2boM0J1j9E4pGy2mm02DEA374FqpxZdaSIPKeU9FAEsKf/ZAeB+xb15u/kWd4S12hRe4jL30LKT+LinJGQ4ITTUlruPegotEwNQjJQdQrB9m16XchQIFnWxQ46XTv6zoBWN4G6CghtErzr1JCm/C3Qwnyzjv35Pkhfbk/G15gBv1DjS+1tEbjMJqfSBFG+VwhLISavm4UrrL5f2GtHzpFUNupbX/CfIIoUxiLIht2H6QjFHZsgFpkzRndaeNUql9YEUR60pnTvPD4dVhzOu3roI4tSmjf3epbIYZ9evab0giNeOO/VWqNkXl2KGmefTVDwfYfctgbJR5gvnj7TIHpbXM1Xo0HtGCxK1oW9WlA6WBtnKwODqgD0vuRa/Mdmr3trKVLu/fYc3HVIkQO43OpdbBAzNLw2GC53wnSclwhBe0RCPL5YW7hoeVyqZAccRVH9deaiTUGbs7TMsf+Hc0We0b0bLKQKHc62VSx7kit1cJATH5y6qd2bt57RNMJiU2FV6wSx+aGWBaCZH3P5qBbNqIbDMJU/8ZS0Y5pc17UcWBFsdRI6s3ojg1cAQ2UneHVGt+Y2tmjAziohOpuy2JAmMwZ8FaU=',
    public_key            = 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwgsjWpiHLJQyX1XShZNO5cS8GQPk+73bLSDgPCedJKOc72pSV+/BgPsuSidP71W7ueWY2BZCmbCw4rUsWgIuHpzvYWx7mnWMf5foOy9UiV1podb6yUeisRsrPSFCMeSt1Bop71PL06Cg7OW+JQ9CItFCZg1YtrgVsb+2jNIk7lK0FbZFQ+oC2jxEVGEbvpaEKoP0ZJoVbykoG0IfB1Ys0xdUB1i/AzmzjmQVsylVkYCehYuBEawjpGqLpWOYjoOHZHLOi5G/Y6IPngUs4HxwzozHTzegCct1JwnRSigTSslAZVUOrDv6zyOn645h21IBDcottXnU+DU+VsqWwQm0GwIDAQAB'
where user_id is not null;
select * from mt_user;
select * from mt_user where lower(alias) like lower('%WINSTON CHIEW%');
-----------------------------------------------------------------------

select * from global_config where property_name = 'folderPathForAttachmentFiles';

UPDATE GLOBAL_CONFIG SET rendered = 'Y' WHERE PROPERTY_NAME = 'folderPathForAttachmentFiles';