select top 10 
 convert(datetime, '2018.03.01', 102) AS [Tarih2] /* TARİH */ , 
  convert(nvarchar,convert(datetime, '2018.03.01', 102),104) AS [Tarih] ,
'' AS [EvrakNo] /* SIRA NO */ , 
'' as [BelgeNo], 'DEVİR' AS [Cinsi] /* CİNSİ */ , 
'' AS [EvrakAdi] /* EVRAK ADI */ , 
'' AS [Tipi] /* TİPİ */ ,
SUM(case CHTipIsim when 'Borç' then cha_meblag else 0 end) as Borc,
SUM(case CHTipIsim when 'Alacak' then cha_meblag else 0 end) as Alacak,
0.0 as Bakiye
  FROM dbo.CARI_HESAP_HAREKETLERI_VIEW_WITH_INDEX_03 
  WHERE  cha_kod='06502'  AND cha_cari_cins=0 AND cha_tarihi < '2018.03.01'
  
  UNION ALL 
  
  select top 10 
  convert(datetime, cha_tarihi, 102) AS [Tarih2] /* TARİH */ , 
   convert(nvarchar, cha_tarihi, 104) AS [Tarih] /* TARİH */ , 
convert(varchar,cha_evrakno_sira) AS [EvrakNo] /* SIRA NO */ , 
cha_belge_no as [BelgeNo], CHCinsIsim AS [Cinsi] /* CİNSİ */ , 
CHEvrKisaIsim AS [EvrakAdi] /* EVRAK ADI */ , 
CHTipIsim AS [Tipi] /* TİPİ */ ,
case CHTipIsim when 'Borç' then cha_meblag else 0 end as Borc,
case CHTipIsim when 'Alacak' then cha_meblag else 0 end as Alacak,
0.0 as Bakiye
  FROM dbo.CARI_HESAP_HAREKETLERI_VIEW_WITH_INDEX_03 
  WHERE  cha_kod='06502'  AND cha_cari_cins=0 AND cha_tarihi between '2018.03.01' and '2018.05.05'
  order by [Tarih]
  
  
  --dbo.fn_HamCariFoy(@firmalar,@caricins,@carikod,@grupno,@ilktar,@sontar,@odemeemridegerlemedok,@SomStr,'')