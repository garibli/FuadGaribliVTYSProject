PGDMP     :    &                z         
   ProjeFuadG    15.0    15.0 d    ?           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            ?           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            ?           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            ?           1262    16537 
   ProjeFuadG    DATABASE     ?   CREATE DATABASE "ProjeFuadG" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE "ProjeFuadG";
                postgres    false            ?           0    0    DATABASE "ProjeFuadG"    COMMENT     Z   COMMENT ON DATABASE "ProjeFuadG" IS 'Fuad Garibli Projesi g201210558 vtys altin dukkani';
                   postgres    false    3498            ?            1255    25350    degerial(character)    FUNCTION     ?  CREATE FUNCTION public.degerial(takininki character) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
  DECLARE
    value1 NUMERIC;
    value2 NUMERIC;
	value3 CHAR (15);
  BEGIN
    SELECT "matKod" INTO value3 FROM "Isleme" Where "takiKod" = "takininki";
	SELECT "matGramFiyat" INTO value1 From "Materyal" WHERE "matKod"=value3;
    SELECT "miktar" INTO value2 FROM "Isleme" WHERE "takiKod"="takininki";
    RETURN value1 * value2;
  END;
$$;
 4   DROP FUNCTION public.degerial(takininki character);
       public          postgres    false            ?            1255    25379    delete_high_salary()    FUNCTION     ?   CREATE FUNCTION public.delete_high_salary() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM "Personel" WHERE "ayMaas" > 100000;
  RETURN NULL;
END;
$$;
 +   DROP FUNCTION public.delete_high_salary();
       public          postgres    false            ?            1255    25382    delete_null_rows()    FUNCTION     ?   CREATE FUNCTION public.delete_null_rows() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM "Takim"
  WHERE "bKod" IS NULL AND "yKod" IS NULL AND "kKod" IS NULL;
  RETURN NULL;
END;
$$;
 )   DROP FUNCTION public.delete_null_rows();
       public          postgres    false            ?            1255    25325    maastlye(numeric)    FUNCTION     ?   CREATE FUNCTION public.maastlye(aymaas numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $$BEGIN
    RETURN 10.04 * ayMaas;
END;
$$;
 /   DROP FUNCTION public.maastlye(aymaas numeric);
       public          postgres    false            ?            1255    25329    personelbul(character)    FUNCTION     <  CREATE FUNCTION public.personelbul(numara character) RETURNS TABLE(pnumarasi character, isimsoyisim character varying, aymaas numeric, skod character)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT "pNumarasi", "IsimSoyisim", "ayMaas", "sKod" 
	FROM "Personel"
    WHERE "pNumarasi" = numara;
END;
$$;
 4   DROP FUNCTION public.personelbul(numara character);
       public          postgres    false            ?            1255    25375    takiFiyatiDegistirme()    FUNCTION     ?   CREATE FUNCTION public."takiFiyatiDegistirme"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."tFiyat" <> OLD."tFiyat" THEN
        INSERT INTO "Taki"("tFiyat")
        VALUES(NEW."tFiyat");
    END IF;

    RETURN NEW;
END;
$$;
 /   DROP FUNCTION public."takiFiyatiDegistirme"();
       public          postgres    false            ?            1255    25336    takibul(character)    FUNCTION     D  CREATE FUNCTION public.takibul(takinin character) RETURNS TABLE(takikod character, takiolcu numeric, tfiyat numeric, skod character)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT "takiKod", "takiOlcu", "tFiyat", "sKod" FROM "Taki"
                 WHERE "takiKod" = takinin AND "tFiyat" is NOT NULL;
END;
$$;
 1   DROP FUNCTION public.takibul(takinin character);
       public          postgres    false            ?            1255    25373    takikayitKontrol()    FUNCTION     +  CREATE FUNCTION public."takikayitKontrol"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."tFiyat" IS NULL THEN
            RAISE EXCEPTION 'fiyat alanı boş olamaz';
    END IF;
	IF NEW."sKod" IS NULL THEN
	RAISE EXCEPTION 'Şubeyi belirtiniz';
	END IF;
    RETURN NEW;
END;
$$;
 +   DROP FUNCTION public."takikayitKontrol"();
       public          postgres    false            ?            1255    25337    takilarigoster()    FUNCTION        CREATE FUNCTION public.takilarigoster() RETURNS TABLE(tkodu character, takiolcu numeric, tfiyat numeric, skod character)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT "takiKod", "takiOlcu", "tFiyat", "sKod" FROM "Taki"
                 WHERE "tFiyat" is NOT NULL;
END;
$$;
 '   DROP FUNCTION public.takilarigoster();
       public          postgres    false            ?            1259    24749    Materyal    TABLE     ?   CREATE TABLE public."Materyal" (
    "matKod" character(15) NOT NULL,
    "matAyar" numeric(10,5) NOT NULL,
    "matGramFiyat" numeric(10,2) NOT NULL,
    "matSaflik" numeric(10,5),
    "matUreticiUlke" text,
    "firmaKod" character(8)
);
    DROP TABLE public."Materyal";
       public         heap    postgres    false            ?            1259    24814    Altin    TABLE     >   CREATE TABLE public."Altin" (
)
INHERITS (public."Materyal");
    DROP TABLE public."Altin";
       public         heap    postgres    false    218            ?            1259    24838    Taki    TABLE     ?   CREATE TABLE public."Taki" (
    "takiKod" character(15) NOT NULL,
    "takiOlcu" numeric(10,0),
    "tFiyat" numeric(10,2),
    "sKod" character(10)
);
    DROP TABLE public."Taki";
       public         heap    postgres    false            ?            1259    24941    Bilezik    TABLE     ?   CREATE TABLE public."Bilezik" (
    "bKod" character(15)
)
INHERITS (public."Taki");
ALTER TABLE ONLY public."Bilezik" ALTER COLUMN "tFiyat" SET NOT NULL;
    DROP TABLE public."Bilezik";
       public         heap    postgres    false    222            ?            1259    24763    Gumus    TABLE     >   CREATE TABLE public."Gumus" (
)
INHERITS (public."Materyal");
    DROP TABLE public."Gumus";
       public         heap    postgres    false    218            ?            1259    25199    Isleme    TABLE     ?   CREATE TABLE public."Isleme" (
    "matKod" character(15) NOT NULL,
    "takiKod" character(15) NOT NULL,
    miktar numeric(10,3)
);
    DROP TABLE public."Isleme";
       public         heap    postgres    false            ?            1259    24931    Klon    TABLE     9   CREATE TABLE public."Klon" (
)
INHERITS (public."Taki");
    DROP TABLE public."Klon";
       public         heap    postgres    false    222            ?            1259    24911    Kolye    TABLE     :   CREATE TABLE public."Kolye" (
)
INHERITS (public."Taki");
    DROP TABLE public."Kolye";
       public         heap    postgres    false    222            ?            1259    24952    Kupe    TABLE     R   CREATE TABLE public."Kupe" (
    "kKod" character(15)
)
INHERITS (public."Taki");
    DROP TABLE public."Kupe";
       public         heap    postgres    false    222            ?            1259    16545    Personel    TABLE     ?   CREATE TABLE public."Personel" (
    "pNumarasi" character(15) NOT NULL,
    "IsimSoyisim" character varying(35) NOT NULL,
    "ayMaas" numeric(20,2) NOT NULL,
    "iletisimNumara" text,
    "sKod" character(10) NOT NULL
);
    DROP TABLE public."Personel";
       public         heap    postgres    false            ?            1259    24901    Piercing    TABLE     =   CREATE TABLE public."Piercing" (
)
INHERITS (public."Taki");
    DROP TABLE public."Piercing";
       public         heap    postgres    false    222            ?            1259    24891    Sancak    TABLE     ;   CREATE TABLE public."Sancak" (
)
INHERITS (public."Taki");
    DROP TABLE public."Sancak";
       public         heap    postgres    false    222            ?            1259    16565    Satis    TABLE     ?   CREATE TABLE public."Satis" (
    "sNumara" character(50) NOT NULL,
    "sTarih" date NOT NULL,
    "sFiyat" numeric(5,0) NOT NULL,
    "sKod" character(10),
    "takiKod" character(15) NOT NULL,
    "pNumarasi" character(15) NOT NULL
);
    DROP TABLE public."Satis";
       public         heap    postgres    false            ?            1259    16552    Sube    TABLE     r   CREATE TABLE public."Sube" (
    "sKod" character(10) NOT NULL,
    "sAddress" text,
    "iletisimNumara" text
);
    DROP TABLE public."Sube";
       public         heap    postgres    false            ?            1259    24962    Takim    TABLE     (  CREATE TABLE public."Takim" (
    "bKod" character(15) NOT NULL,
    "yKod" character(15) NOT NULL,
    "kKod" character(15) NOT NULL
)
INHERITS (public."Taki");
ALTER TABLE ONLY public."Takim" ALTER COLUMN "tFiyat" SET NOT NULL;
ALTER TABLE ONLY public."Takim" ALTER COLUMN "sKod" SET NOT NULL;
    DROP TABLE public."Takim";
       public         heap    postgres    false    222            ?            1259    24790    Tas    TABLE     ^   CREATE TABLE public."Tas" (
    "kirmaDerecesi" numeric(10,0)
)
INHERITS (public."Materyal");
    DROP TABLE public."Tas";
       public         heap    postgres    false    218            ?            1259    16538 	   Tedarikci    TABLE     ?   CREATE TABLE public."Tedarikci" (
    "firmaKod" character(8) NOT NULL,
    "tIsim" character varying(50) NOT NULL,
    "addressTed" character varying(500)
);
    DROP TABLE public."Tedarikci";
       public         heap    postgres    false            ?            1259    24921    Yuzuk    TABLE     S   CREATE TABLE public."Yuzuk" (
    "yKod" character(15)
)
INHERITS (public."Taki");
    DROP TABLE public."Yuzuk";
       public         heap    postgres    false    222            ?          0    24814    Altin 
   TABLE DATA           q   COPY public."Altin" ("matKod", "matAyar", "matGramFiyat", "matSaflik", "matUreticiUlke", "firmaKod") FROM stdin;
    public          postgres    false    221   w       ?          0    24941    Bilezik 
   TABLE DATA           T   COPY public."Bilezik" ("takiKod", "takiOlcu", "tFiyat", "sKod", "bKod") FROM stdin;
    public          postgres    false    228   ?w       ?          0    24763    Gumus 
   TABLE DATA           q   COPY public."Gumus" ("matKod", "matAyar", "matGramFiyat", "matSaflik", "matUreticiUlke", "firmaKod") FROM stdin;
    public          postgres    false    219   	x       ?          0    25199    Isleme 
   TABLE DATA           ?   COPY public."Isleme" ("matKod", "takiKod", miktar) FROM stdin;
    public          postgres    false    231   |x       ?          0    24931    Klon 
   TABLE DATA           I   COPY public."Klon" ("takiKod", "takiOlcu", "tFiyat", "sKod") FROM stdin;
    public          postgres    false    227   	y       ?          0    24911    Kolye 
   TABLE DATA           J   COPY public."Kolye" ("takiKod", "takiOlcu", "tFiyat", "sKod") FROM stdin;
    public          postgres    false    225   gy       ?          0    24952    Kupe 
   TABLE DATA           Q   COPY public."Kupe" ("takiKod", "takiOlcu", "tFiyat", "sKod", "kKod") FROM stdin;
    public          postgres    false    229   ?y       ?          0    24749    Materyal 
   TABLE DATA           t   COPY public."Materyal" ("matKod", "matAyar", "matGramFiyat", "matSaflik", "matUreticiUlke", "firmaKod") FROM stdin;
    public          postgres    false    218   Sz       ?          0    16545    Personel 
   TABLE DATA           d   COPY public."Personel" ("pNumarasi", "IsimSoyisim", "ayMaas", "iletisimNumara", "sKod") FROM stdin;
    public          postgres    false    215   ?z       ?          0    24901    Piercing 
   TABLE DATA           M   COPY public."Piercing" ("takiKod", "takiOlcu", "tFiyat", "sKod") FROM stdin;
    public          postgres    false    224   3|       ?          0    24891    Sancak 
   TABLE DATA           K   COPY public."Sancak" ("takiKod", "takiOlcu", "tFiyat", "sKod") FROM stdin;
    public          postgres    false    223   ?|       ?          0    16565    Satis 
   TABLE DATA           `   COPY public."Satis" ("sNumara", "sTarih", "sFiyat", "sKod", "takiKod", "pNumarasi") FROM stdin;
    public          postgres    false    217   .}       ?          0    16552    Sube 
   TABLE DATA           F   COPY public."Sube" ("sKod", "sAddress", "iletisimNumara") FROM stdin;
    public          postgres    false    216   ?}       ?          0    24838    Taki 
   TABLE DATA           I   COPY public."Taki" ("takiKod", "takiOlcu", "tFiyat", "sKod") FROM stdin;
    public          postgres    false    222   <~       ?          0    24962    Takim 
   TABLE DATA           b   COPY public."Takim" ("takiKod", "takiOlcu", "tFiyat", "sKod", "bKod", "yKod", "kKod") FROM stdin;
    public          postgres    false    230   #       ?          0    24790    Tas 
   TABLE DATA           ?   COPY public."Tas" ("matKod", "matAyar", "matGramFiyat", "matSaflik", "matUreticiUlke", "firmaKod", "kirmaDerecesi") FROM stdin;
    public          postgres    false    220   ?       ?          0    16538 	   Tedarikci 
   TABLE DATA           H   COPY public."Tedarikci" ("firmaKod", "tIsim", "addressTed") FROM stdin;
    public          postgres    false    214   ?       ?          0    24921    Yuzuk 
   TABLE DATA           R   COPY public."Yuzuk" ("takiKod", "takiOlcu", "tFiyat", "sKod", "yKod") FROM stdin;
    public          postgres    false    226   ??       ?           2606    24820    Altin Altin_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public."Altin"
    ADD CONSTRAINT "Altin_pkey" PRIMARY KEY ("matKod");
 >   ALTER TABLE ONLY public."Altin" DROP CONSTRAINT "Altin_pkey";
       public            postgres    false    221            ?           2606    24946    Bilezik Bilezik_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public."Bilezik"
    ADD CONSTRAINT "Bilezik_pkey" PRIMARY KEY ("takiKod");
 B   ALTER TABLE ONLY public."Bilezik" DROP CONSTRAINT "Bilezik_pkey";
       public            postgres    false    228            ?           2606    25226    Isleme Isleme_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public."Isleme"
    ADD CONSTRAINT "Isleme_pkey" PRIMARY KEY ("matKod", "takiKod");
 @   ALTER TABLE ONLY public."Isleme" DROP CONSTRAINT "Isleme_pkey";
       public            postgres    false    231    231            ?           2606    24935    Klon Klon_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public."Klon"
    ADD CONSTRAINT "Klon_pkey" PRIMARY KEY ("takiKod");
 <   ALTER TABLE ONLY public."Klon" DROP CONSTRAINT "Klon_pkey";
       public            postgres    false    227            ?           2606    24915    Kolye Kolye_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public."Kolye"
    ADD CONSTRAINT "Kolye_pkey" PRIMARY KEY ("takiKod");
 >   ALTER TABLE ONLY public."Kolye" DROP CONSTRAINT "Kolye_pkey";
       public            postgres    false    225            ?           2606    24956    Kupe Kupe_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public."Kupe"
    ADD CONSTRAINT "Kupe_pkey" PRIMARY KEY ("takiKod");
 <   ALTER TABLE ONLY public."Kupe" DROP CONSTRAINT "Kupe_pkey";
       public            postgres    false    229            ?           2606    25020    Personel Personel_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public."Personel"
    ADD CONSTRAINT "Personel_pkey" PRIMARY KEY ("pNumarasi");
 D   ALTER TABLE ONLY public."Personel" DROP CONSTRAINT "Personel_pkey";
       public            postgres    false    215            ?           2606    24905    Piercing Piercing_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public."Piercing"
    ADD CONSTRAINT "Piercing_pkey" PRIMARY KEY ("takiKod");
 D   ALTER TABLE ONLY public."Piercing" DROP CONSTRAINT "Piercing_pkey";
       public            postgres    false    224            ?           2606    24895    Sancak Sancak_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public."Sancak"
    ADD CONSTRAINT "Sancak_pkey" PRIMARY KEY ("takiKod");
 @   ALTER TABLE ONLY public."Sancak" DROP CONSTRAINT "Sancak_pkey";
       public            postgres    false    223            ?           2606    16569    Satis Satis_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public."Satis"
    ADD CONSTRAINT "Satis_pkey" PRIMARY KEY ("sNumara");
 >   ALTER TABLE ONLY public."Satis" DROP CONSTRAINT "Satis_pkey";
       public            postgres    false    217            ?           2606    25362    Satis Satisnumarasiun 
   CONSTRAINT     Y   ALTER TABLE ONLY public."Satis"
    ADD CONSTRAINT "Satisnumarasiun" UNIQUE ("sNumara");
 C   ALTER TABLE ONLY public."Satis" DROP CONSTRAINT "Satisnumarasiun";
       public            postgres    false    217            ?           2606    25018    Sube Sube_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public."Sube"
    ADD CONSTRAINT "Sube_pkey" PRIMARY KEY ("sKod");
 <   ALTER TABLE ONLY public."Sube" DROP CONSTRAINT "Sube_pkey";
       public            postgres    false    216            ?           2606    24860    Taki Taki_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public."Taki"
    ADD CONSTRAINT "Taki_pkey" PRIMARY KEY ("takiKod");
 <   ALTER TABLE ONLY public."Taki" DROP CONSTRAINT "Taki_pkey";
       public            postgres    false    222            ?           2606    24999    Takim Takim_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public."Takim"
    ADD CONSTRAINT "Takim_pkey" PRIMARY KEY ("takiKod");
 >   ALTER TABLE ONLY public."Takim" DROP CONSTRAINT "Takim_pkey";
       public            postgres    false    230            ?           2606    24808    Tas Tas_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public."Tas"
    ADD CONSTRAINT "Tas_pkey" PRIMARY KEY ("matKod");
 :   ALTER TABLE ONLY public."Tas" DROP CONSTRAINT "Tas_pkey";
       public            postgres    false    220            ?           2606    16544    Tedarikci Tedarikci_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public."Tedarikci"
    ADD CONSTRAINT "Tedarikci_pkey" PRIMARY KEY ("firmaKod");
 F   ALTER TABLE ONLY public."Tedarikci" DROP CONSTRAINT "Tedarikci_pkey";
       public            postgres    false    214            ?           2606    24925    Yuzuk Yuzuk_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public."Yuzuk"
    ADD CONSTRAINT "Yuzuk_pkey" PRIMARY KEY ("takiKod");
 >   ALTER TABLE ONLY public."Yuzuk" DROP CONSTRAINT "Yuzuk_pkey";
       public            postgres    false    226            ?           2606    25006    Bilezik bbkod_unique 
   CONSTRAINT     S   ALTER TABLE ONLY public."Bilezik"
    ADD CONSTRAINT bbkod_unique UNIQUE ("bKod");
 @   ALTER TABLE ONLY public."Bilezik" DROP CONSTRAINT bbkod_unique;
       public            postgres    false    228            ?           2606    24757    Tedarikci firmaKod_unique 
   CONSTRAINT     ^   ALTER TABLE ONLY public."Tedarikci"
    ADD CONSTRAINT "firmaKod_unique" UNIQUE ("firmaKod");
 G   ALTER TABLE ONLY public."Tedarikci" DROP CONSTRAINT "firmaKod_unique";
       public            postgres    false    214            ?           2606    25304    Gumus gumus_unique 
   CONSTRAINT     S   ALTER TABLE ONLY public."Gumus"
    ADD CONSTRAINT gumus_unique UNIQUE ("matKod");
 >   ALTER TABLE ONLY public."Gumus" DROP CONSTRAINT gumus_unique;
       public            postgres    false    219            ?           2606    25352    Klon klonunique 
   CONSTRAINT     Q   ALTER TABLE ONLY public."Klon"
    ADD CONSTRAINT klonunique UNIQUE ("takiKod");
 ;   ALTER TABLE ONLY public."Klon" DROP CONSTRAINT klonunique;
       public            postgres    false    227            ?           2606    25354    Kolye kolyeunique 
   CONSTRAINT     S   ALTER TABLE ONLY public."Kolye"
    ADD CONSTRAINT kolyeunique UNIQUE ("takiKod");
 =   ALTER TABLE ONLY public."Kolye" DROP CONSTRAINT kolyeunique;
       public            postgres    false    225            ?           2606    24997    Kupe kupe_unique 
   CONSTRAINT     O   ALTER TABLE ONLY public."Kupe"
    ADD CONSTRAINT kupe_unique UNIQUE ("kKod");
 <   ALTER TABLE ONLY public."Kupe" DROP CONSTRAINT kupe_unique;
       public            postgres    false    229            ?           2606    24755    Materyal matKod 
   CONSTRAINT     W   ALTER TABLE ONLY public."Materyal"
    ADD CONSTRAINT "matKod" PRIMARY KEY ("matKod");
 =   ALTER TABLE ONLY public."Materyal" DROP CONSTRAINT "matKod";
       public            postgres    false    218            ?           2606    24769    Gumus matKod_pk 
   CONSTRAINT     W   ALTER TABLE ONLY public."Gumus"
    ADD CONSTRAINT "matKod_pk" PRIMARY KEY ("matKod");
 =   ALTER TABLE ONLY public."Gumus" DROP CONSTRAINT "matKod_pk";
       public            postgres    false    219            ?           2606    25356    Materyal materyalunique 
   CONSTRAINT     X   ALTER TABLE ONLY public."Materyal"
    ADD CONSTRAINT materyalunique UNIQUE ("matKod");
 C   ALTER TABLE ONLY public."Materyal" DROP CONSTRAINT materyalunique;
       public            postgres    false    218            ?           2606    25302    Altin matkod 
   CONSTRAINT     M   ALTER TABLE ONLY public."Altin"
    ADD CONSTRAINT matkod UNIQUE ("matKod");
 8   ALTER TABLE ONLY public."Altin" DROP CONSTRAINT matkod;
       public            postgres    false    221            ?           2606    24743    Personel pNumarasi 
   CONSTRAINT     X   ALTER TABLE ONLY public."Personel"
    ADD CONSTRAINT "pNumarasi" UNIQUE ("pNumarasi");
 @   ALTER TABLE ONLY public."Personel" DROP CONSTRAINT "pNumarasi";
       public            postgres    false    215            ?           2606    25358    Piercing piercingunique 
   CONSTRAINT     Y   ALTER TABLE ONLY public."Piercing"
    ADD CONSTRAINT piercingunique UNIQUE ("takiKod");
 C   ALTER TABLE ONLY public."Piercing" DROP CONSTRAINT piercingunique;
       public            postgres    false    224            ?           2606    24730 	   Sube sKod 
   CONSTRAINT     J   ALTER TABLE ONLY public."Sube"
    ADD CONSTRAINT "sKod" UNIQUE ("sKod");
 7   ALTER TABLE ONLY public."Sube" DROP CONSTRAINT "sKod";
       public            postgres    false    216            ?           2606    25360    Sancak sancakunique 
   CONSTRAINT     U   ALTER TABLE ONLY public."Sancak"
    ADD CONSTRAINT sancakunique UNIQUE ("takiKod");
 ?   ALTER TABLE ONLY public."Sancak" DROP CONSTRAINT sancakunique;
       public            postgres    false    223            ?           2606    24862    Taki takiKod 
   CONSTRAINT     P   ALTER TABLE ONLY public."Taki"
    ADD CONSTRAINT "takiKod" UNIQUE ("takiKod");
 :   ALTER TABLE ONLY public."Taki" DROP CONSTRAINT "takiKod";
       public            postgres    false    222            ?           2606    25306    Tas tas_unique 
   CONSTRAINT     O   ALTER TABLE ONLY public."Tas"
    ADD CONSTRAINT tas_unique UNIQUE ("matKod");
 :   ALTER TABLE ONLY public."Tas" DROP CONSTRAINT tas_unique;
       public            postgres    false    220            ?           2606    24981    Yuzuk yKod_unique 
   CONSTRAINT     R   ALTER TABLE ONLY public."Yuzuk"
    ADD CONSTRAINT "yKod_unique" UNIQUE ("yKod");
 ?   ALTER TABLE ONLY public."Yuzuk" DROP CONSTRAINT "yKod_unique";
       public            postgres    false    226            ?           1259    24736    fki_sKod    INDEX     C   CREATE INDEX "fki_sKod" ON public."Personel" USING btree ("sKod");
    DROP INDEX public."fki_sKod";
       public            postgres    false    215                       2620    25380    Personel delete_high_salary    TRIGGER     ?   CREATE TRIGGER delete_high_salary AFTER INSERT OR DELETE OR UPDATE OR TRUNCATE ON public."Personel" FOR EACH STATEMENT EXECUTE FUNCTION public.delete_high_salary();
 6   DROP TRIGGER delete_high_salary ON public."Personel";
       public          postgres    false    215    249                       2620    25383    Takim delete_null_rows    TRIGGER     ?   CREATE TRIGGER delete_null_rows AFTER INSERT OR DELETE OR UPDATE OR TRUNCATE ON public."Takim" FOR EACH STATEMENT EXECUTE FUNCTION public.delete_null_rows();
 1   DROP TRIGGER delete_null_rows ON public."Takim";
       public          postgres    false    230    232                       2620    25374    Taki kayitKontrol    TRIGGER     ?   CREATE TRIGGER "kayitKontrol" BEFORE INSERT OR UPDATE ON public."Taki" FOR EACH ROW EXECUTE FUNCTION public."takikayitKontrol"();

ALTER TABLE public."Taki" DISABLE TRIGGER "kayitKontrol";
 .   DROP TRIGGER "kayitKontrol" ON public."Taki";
       public          postgres    false    222    250                       2620    25376    Taki takiFiyatDegisimi    TRIGGER     ?   CREATE TRIGGER "takiFiyatDegisimi" BEFORE UPDATE ON public."Taki" FOR EACH ROW EXECUTE FUNCTION public."takiFiyatiDegistirme"();
 3   DROP TRIGGER "takiFiyatDegisimi" ON public."Taki";
       public          postgres    false    251    222            ?           2606    24758    Materyal firmaKod_fk    FK CONSTRAINT     ?   ALTER TABLE ONLY public."Materyal"
    ADD CONSTRAINT "firmaKod_fk" FOREIGN KEY ("firmaKod") REFERENCES public."Tedarikci"("firmaKod");
 B   ALTER TABLE ONLY public."Materyal" DROP CONSTRAINT "firmaKod_fk";
       public          postgres    false    214    3250    218            ?           2606    25307    Isleme islemematkod_fk    FK CONSTRAINT     ?   ALTER TABLE ONLY public."Isleme"
    ADD CONSTRAINT islemematkod_fk FOREIGN KEY ("matKod") REFERENCES public."Materyal"("matKod");
 B   ALTER TABLE ONLY public."Isleme" DROP CONSTRAINT islemematkod_fk;
       public          postgres    false    231    3267    218                        2606    25312    Isleme islemetakikod_fk    FK CONSTRAINT     ?   ALTER TABLE ONLY public."Isleme"
    ADD CONSTRAINT islemetakikod_fk FOREIGN KEY ("takiKod") REFERENCES public."Taki"("takiKod");
 C   ALTER TABLE ONLY public."Isleme" DROP CONSTRAINT islemetakikod_fk;
       public          postgres    false    3283    231    222            ?           2606    24744    Satis pNumarasi_fk    FK CONSTRAINT     ?   ALTER TABLE ONLY public."Satis"
    ADD CONSTRAINT "pNumarasi_fk" FOREIGN KEY ("pNumarasi") REFERENCES public."Personel"("pNumarasi");
 @   ALTER TABLE ONLY public."Satis" DROP CONSTRAINT "pNumarasi_fk";
       public          postgres    false    217    3257    215            ?           2606    24737    Personel sKod_fk    FK CONSTRAINT     w   ALTER TABLE ONLY public."Personel"
    ADD CONSTRAINT "sKod_fk" FOREIGN KEY ("sKod") REFERENCES public."Sube"("sKod");
 >   ALTER TABLE ONLY public."Personel" DROP CONSTRAINT "sKod_fk";
       public          postgres    false    216    215    3261            ?           2606    24876    Satis sKod_fk    FK CONSTRAINT     t   ALTER TABLE ONLY public."Satis"
    ADD CONSTRAINT "sKod_fk" FOREIGN KEY ("sKod") REFERENCES public."Sube"("sKod");
 ;   ALTER TABLE ONLY public."Satis" DROP CONSTRAINT "sKod_fk";
       public          postgres    false    3261    216    217            ?           2606    25330    Satis satistaki_fk    FK CONSTRAINT     ?   ALTER TABLE ONLY public."Satis"
    ADD CONSTRAINT satistaki_fk FOREIGN KEY ("takiKod") REFERENCES public."Taki"("takiKod") NOT VALID;
 >   ALTER TABLE ONLY public."Satis" DROP CONSTRAINT satistaki_fk;
       public          postgres    false    222    3283    217            ?           2606    24843    Taki taki_fk    FK CONSTRAINT     q   ALTER TABLE ONLY public."Taki"
    ADD CONSTRAINT taki_fk FOREIGN KEY ("sKod") REFERENCES public."Sube"("sKod");
 8   ALTER TABLE ONLY public."Taki" DROP CONSTRAINT taki_fk;
       public          postgres    false    222    3261    216            ?           2606    25007    Takim takimb_fk    FK CONSTRAINT     w   ALTER TABLE ONLY public."Takim"
    ADD CONSTRAINT takimb_fk FOREIGN KEY ("bKod") REFERENCES public."Bilezik"("bKod");
 ;   ALTER TABLE ONLY public."Takim" DROP CONSTRAINT takimb_fk;
       public          postgres    false    3309    228    230            ?           2606    25000    Takim takimk_fk    FK CONSTRAINT     t   ALTER TABLE ONLY public."Takim"
    ADD CONSTRAINT takimk_fk FOREIGN KEY ("kKod") REFERENCES public."Kupe"("kKod");
 ;   ALTER TABLE ONLY public."Takim" DROP CONSTRAINT takimk_fk;
       public          postgres    false    230    3313    229            ?           2606    24991    Takim takimy_fk    FK CONSTRAINT     u   ALTER TABLE ONLY public."Takim"
    ADD CONSTRAINT takimy_fk FOREIGN KEY ("yKod") REFERENCES public."Yuzuk"("yKod");
 ;   ALTER TABLE ONLY public."Takim" DROP CONSTRAINT takimy_fk;
       public          postgres    false    230    3301    226            ?   ]   x?K400V@ NC=?43?35??0?r?J??39Ӡʹ?P??@????Pnh?#?&dMF0M? ?,??$?{dCIb?m1z\\\ [??      ?   t   x?m??? ?s;??B??N????bQ?r?y??i%??y7`I?"?aٱ??u?\?uѸ?Ņԝ???P0!?Y˃)?ƭ͑<?_.}?Xb??PyJ-4.1m>#,O2?3w      ?   c   x?K700R@ N=?4??35??0?r?R??3??8?L@j?????[@???9??(;?2E?1?NKK?RKT[C23s?R:c???? ??$      ?   }   x?u?A? е??0???]?ԦE?]?4???<YexOX??T???e????nɱ??@??Q????N??r+r?TIS?????@0qS???u`(???R?C??????bo_U?Qu?3?OɯG?      ?   N   x???100U?NsN3s=?b#?W6P?	??#?C$%?HJ?8M??L??#)1"l?!?)P%0?b???? ??~      ?   Y   x?m?K
?0E?q?
WP^~?Ÿ???`??a8??N?n?Q%?? t???u?8??0??'??0??MF?-?Zj?h?d???uf??$`      ?   s   x?m???0?3L??u	'?=???F????|??0.?uyH?["????c?p?k?U?V???mֱ^J?Չwl??07?'Tl?h߿P	????Bs???>ͫ/?]@?"ޒ=?      ?   ?   x?]?1?0?ٜ?'@C??^ K?-K?????:?@<<????????!?*-?Ji[?;;'?	?????t?\?w?g4?Zt???̧?ۣ????wGh???Y?c??+??{?|????5?Ź?#_?wV???{z???! | 1?I]      ?   0  x?]?Mn? F????0?2??f??????ȨAE~??2]v?3?+?mC?X?????H~;?????:??spJ4
??J??_? *G?t?????NL@	?f3??65??lrx?5????v????	?_(?+DeNx??????????D?7_`:#?7???%?Ყ?s??}?_???Z?hP??:7,?;?и7?p??w|e??mm??(AD?U??*???E????k?P?tDe?U???L5?!r??H??ޥJ???Uq3?ov??y|?=m?9??DQ??? ?"u-0?k^ˢ(~ ?ׁt      ?   q   x?e??	? F??8E'?/?Ew?B??
?DÁ?8?????$+????	g????tc:?Iۈ1??GL?ŚAm!Q???UE?\9r?\].{?~?ҁ?N?:6(/T?W?1??,?:?      ?   j   x?m??	?0??t
'(?4i?.?8C????|???O????(5?P?y?~?6??| ?Fd???,"&?Yl??E??*???\??P?(????#)˲??)?E2/      ?   K   x?+N,?,600R p???s?p5B%*??????b?v???2?e??? ?]1z\\\ ??"?      ?   ?   x?uͻ?0??:??`?M?0@$??47R$?M"?8,?? 3?⡴???NbL?oEܹ? ?=H
M?`tGƉ?}?P_?ء;?PT???c?Z?ĘX??5???{?O???b???6?(??t¡ˡ`Zr?7?~	?M??O(?????\pɭ?dWB޺]8?      ?   ?   x?u?A?0@ѵ=?' S(???l??P?$??7H?oؽ???#?Hw?????=aib"?o͸?8?q'?	>???a$z?D????Jw?J)??%*]?RZ?UZQ=??7?0p{?=?n??Rhx?ᅆ^`?w^??}?	A<A???
fj?)m??˴W??¿??ߒ
/ ?m???
V*XaK???H#?ad???!"      ?   h   x?]?1? ?ᙞ??b??Kx?qno?????K[<ND??3a5n^?"?ql????Ϊ?? U??ʞ?????T?ꢊ?S?PGbo??ꤒUU, <??-?      ?   t   x?+100V@ N=sNS3=#SNKc=S߭(1/9?3??????Ѐ????U/D?????	??;"4?5?j4+442i4??j9??(;?l?D??1W? ?"      ?   ?   x?m˽? ????\ 1?s?A?&?us?l Kit??K?}??uZ_?$??n?6?+<?%??go???\?9e
+?:~mʊ?eF??<U???Lw?x?,L?"???vw??L?聍???u?R? ?90?      ?   ?   x????!?3T?
???짉T?]???g?????<N??St-ꋨ??}S?g=?_?	?G??V?*@w????<??h???ߖ?h?w??4???;?C\2}??????{?sڬ;Zv?h]B}h?3\S???pD????+??Z??Zb     