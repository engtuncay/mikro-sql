
-- 0 giriş , 1 çıkış

select sth_stok_kod,sum(
case when sth_giris_cikis=0 THEN sth_miktar
when sth_giris_cikis=1 THEN sth_miktar*-1 
end) as stok_miktari,sth_depono from [STOK_HAREKETLERI_GIRIS_CIKIS] WHERE sth_stok_kod='0013852'
group by sth_stok_kod,sth_depono


--select * from STOKLAR_CHOOSE_3A

