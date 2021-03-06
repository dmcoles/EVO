OPT MODULE
OPT EXPORT

CONST INVALID_ID=-1,
      MONITOR_ID_MASK=$FFFF1000,
      DEFAULT_MONITOR_ID=0,
      NTSC_MONITOR_ID=$11000,
      PAL_MONITOR_ID=$21000,
      LORES_KEY=0,
      HIRES_KEY=$8000,
      SUPER_KEY=$8020,
      HAM_KEY=$800,
      LORESLACE_KEY=4,
      HIRESLACE_KEY=$8004,
      SUPERLACE_KEY=$8024,
      HAMLACE_KEY=$804,
      LORESDPF_KEY=$400,
      HIRESDPF_KEY=$8400,
      SUPERDPF_KEY=$8420,
      LORESLACEDPF_KEY=$404,
      HIRESLACEDPF_KEY=$8404,
      SUPERLACEDPF_KEY=$8424,
      LORESDPF2_KEY=$440,
      HIRESDPF2_KEY=$8440,
      SUPERDPF2_KEY=$8460,
      LORESLACEDPF2_KEY=$444,
      HIRESLACEDPF2_KEY=$8444,
      SUPERLACEDPF2_KEY=$8464,
      EXTRAHALFBRITE_KEY=$80,
      EXTRAHALFBRITELACE_KEY=$84,
      HIRESHAM_KEY=$8800,
      SUPERHAM_KEY=$8820,
      HIRESEHB_KEY=$8080,
      SUPEREHB_KEY=$80A0,
      HIRESHAMLACE_KEY=$8804,
      SUPERHAMLACE_KEY=$8824,
      HIRESEHBLACE_KEY=$8084,
      SUPEREHBLACE_KEY=$80A4,
      LORESSDBL_KEY=8,
      LORESHAMSDBL_KEY=$808,
      LORESEHBSDBL_KEY=$88,
      HIRESHAMSDBL_KEY=$8808,
      VGA_MONITOR_ID=$31000,
      VGAEXTRALORES_KEY=$31004,
      VGALORES_KEY=$39004,
      VGAPRODUCT_KEY=$39024,
      VGAHAM_KEY=$31804,
      VGAEXTRALORESLACE_KEY=$31005,
      VGALORESLACE_KEY=$39005,
      VGAPRODUCTLACE_KEY=$39025,
      VGAHAMLACE_KEY=$31805,
      VGAEXTRALORESDPF_KEY=$31404,
      VGALORESDPF_KEY=$39404,
      VGAPRODUCTDPF_KEY=$39424,
      VGAEXTRALORESLACEDPF_KEY=$31405,
      VGALORESLACEDPF_KEY=$39405,
      VGAPRODUCTLACEDPF_KEY=$39425,
      VGAEXTRALORESDPF2_KEY=$31444,
      VGALORESDPF2_KEY=$39444,
      VGAPRODUCTDPF2_KEY=$39464,
      VGAEXTRALORESLACEDPF2_KEY=$31445,
      VGALORESLACEDPF2_KEY=$39445,
      VGAPRODUCTLACEDPF2_KEY=$39465,
      VGAEXTRAHALFBRITE_KEY=$31084,
      VGAEXTRAHALFBRITELACE_KEY=$31085,
      VGAPRODUCTHAM_KEY=$39824,
      VGALORESHAM_KEY=$39804,
      VGAEXTRALORESHAM_KEY=$31804,
      VGAPRODUCTHAMLACE_KEY=$39825,
      VGALORESHAMLACE_KEY=$39805,
      VGAEXTRALORESHAMLACE_KEY=$31805,
      VGAEXTRALORESEHB_KEY=$31084,
      VGAEXTRALORESEHBLACE_KEY=$31085,
      VGALORESEHB_KEY=$39084,
      VGALORESEHBLACE_KEY=$39085,
      VGAEHB_KEY=$390A4,
      VGAEHBLACE_KEY=$390A5,
      VGAEXTRALORESDBL_KEY=$31000,
      VGALORESDBL_KEY=$39000,
      VGAPRODUCTDBL_KEY=$39020,
      VGAEXTRALORESHAMDBL_KEY=$31800,
      VGALORESHAMDBL_KEY=$39800,
      VGAPRODUCTHAMDBL_KEY=$39820,
      VGAEXTRALORESEHBDBL_KEY=$31080,
      VGALORESEHBDBL_KEY=$39080,
      VGAPRODUCTEHBDBL_KEY=$390A0,
      A2024_MONITOR_ID=$41000,
      A2024TENHERTZ_KEY=$41000,
      A2024FIFTEENHERTZ_KEY=$49000,
      PROTO_MONITOR_ID=$51000,
      EURO72_MONITOR_ID=$61000,
      EURO72EXTRALORES_KEY=$61004,
      EURO72LORES_KEY=$69004,
      EURO72PRODUCT_KEY=$69024,
      EURO72HAM_KEY=$61804,
      EURO72EXTRALORESLACE_KEY=$61005,
      EURO72LORESLACE_KEY=$69005,
      EURO72PRODUCTLACE_KEY=$69025,
      EURO72HAMLACE_KEY=$61805,
      EURO72EXTRALORESDPF_KEY=$61404,
      EURO72LORESDPF_KEY=$69404,
      EURO72PRODUCTDPF_KEY=$69424,
      EURO72EXTRALORESLACEDPF_KEY=$61405,
      EURO72LORESLACEDPF_KEY=$69405,
      EURO72PRODUCTLACEDPF_KEY=$69425,
      EURO72EXTRALORESDPF2_KEY=$61444,
      EURO72LORESDPF2_KEY=$69444,
      EURO72PRODUCTDPF2_KEY=$69464,
      EURO72EXTRALORESLACEDPF2_KEY=$61445,
      EURO72LORESLACEDPF2_KEY=$69445,
      EURO72PRODUCTLACEDPF2_KEY=$69465,
      EURO72EXTRAHALFBRITE_KEY=$61084,
      EURO72EXTRAHALFBRITELACE_KEY=$61085,
      EURO72PRODUCTHAM_KEY=$69824,
      EURO72PRODUCTHAMLACE_KEY=$69825,
      EURO72LORESHAM_KEY=$69804,
      EURO72LORESHAMLACE_KEY=$69805,
      EURO72EXTRALORESHAM_KEY=$61804,
      EURO72EXTRALORESHAMLACE_KEY=$61805,
      EURO72EXTRALORESEHB_KEY=$61084,
      EURO72EXTRALORESEHBLACE_KEY=$61085,
      EURO72LORESEHB_KEY=$69084,
      EURO72LORESEHBLACE_KEY=$69085,
      EURO72EHB_KEY=$690A4,
      EURO72EHBLACE_KEY=$690A5,
      EURO72EXTRALORESDBL_KEY=$61000,
      EURO72LORESDBL_KEY=$69000,
      EURO72PRODUCTDBL_KEY=$69020,
      EURO72EXTRALORESHAMDBL_KEY=$61800,
      EURO72LORESHAMDBL_KEY=$69800,
      EURO72PRODUCTHAMDBL_KEY=$69820,
      EURO72EXTRALORESEHBDBL_KEY=$61080,
      EURO72LORESEHBDBL_KEY=$69080,
      EURO72PRODUCTEHBDBL_KEY=$690A0,
      EURO36_MONITOR_ID=$71000,
      SUPER72_MONITOR_ID=$81000,
      SUPER72LORESDBL_KEY=$81008,
      SUPER72HIRESDBL_KEY=$89008,
      SUPER72SUPERDBL_KEY=$89028,
      SUPER72LORESHAMDBL_KEY=$81808,
      SUPER72HIRESHAMDBL_KEY=$89808,
      SUPER72SUPERHAMDBL_KEY=$89828,
      SUPER72LORESEHBDBL_KEY=$81088,
      SUPER72HIRESEHBDBL_KEY=$89088,
      SUPER72SUPEREHBDBL_KEY=$890A8,
      DBLNTSC_MONITOR_ID=$91000,
      DBLNTSCLORES_KEY=$91000,
      DBLNTSCLORESFF_KEY=$91004,
      DBLNTSCLORESHAM_KEY=$91800,
      DBLNTSCLORESHAMFF_KEY=$91804,
      DBLNTSCLORESEHB_KEY=$91080,
      DBLNTSCLORESEHBFF_KEY=$91084,
      DBLNTSCLORESLACE_KEY=$91005,
      DBLNTSCLORESHAMLACE_KEY=$91805,
      DBLNTSCLORESEHBLACE_KEY=$91085,
      DBLNTSCLORESDPF_KEY=$91400,
      DBLNTSCLORESDPFFF_KEY=$91404,
      DBLNTSCLORESDPFLACE_KEY=$91405,
      DBLNTSCLORESDPF2_KEY=$91440,
      DBLNTSCLORESDPF2FF_KEY=$91444,
      DBLNTSCLORESDPF2LACE_KEY=$91445,
      DBLNTSCHIRES_KEY=$99000,
      DBLNTSCHIRESFF_KEY=$99004,
      DBLNTSCHIRESHAM_KEY=$99800,
      DBLNTSCHIRESHAMFF_KEY=$99804,
      DBLNTSCHIRESLACE_KEY=$99005,
      DBLNTSCHIRESHAMLACE_KEY=$99805,
      DBLNTSCHIRESEHB_KEY=$99080,
      DBLNTSCHIRESEHBFF_KEY=$99084,
      DBLNTSCHIRESEHBLACE_KEY=$99085,
      DBLNTSCHIRESDPF_KEY=$99400,
      DBLNTSCHIRESDPFFF_KEY=$99404,
      DBLNTSCHIRESDPFLACE_KEY=$99405,
      DBLNTSCHIRESDPF2_KEY=$99440,
      DBLNTSCHIRESDPF2FF_KEY=$99444,
      DBLNTSCHIRESDPF2LACE_KEY=$99445,
      DBLNTSCEXTRALORES_KEY=$91200,
      DBLNTSCEXTRALORESHAM_KEY=$91A00,
      DBLNTSCEXTRALORESEHB_KEY=$91280,
      DBLNTSCEXTRALORESDPF_KEY=$91600,
      DBLNTSCEXTRALORESDPF2_KEY=$91640,
      DBLNTSCEXTRALORESFF_KEY=$91204,
      DBLNTSCEXTRALORESHAMFF_KEY=$91A04,
      DBLNTSCEXTRALORESEHBFF_KEY=$91284,
      DBLNTSCEXTRALORESDPFFF_KEY=$91604,
      DBLNTSCEXTRALORESDPF2FF_KEY=$91644,
      DBLNTSCEXTRALORESLACE_KEY=$91205,
      DBLNTSCEXTRALORESHAMLACE_KEY=$91A05,
      DBLNTSCEXTRALORESEHBLACE_KEY=$91285,
      DBLNTSCEXTRALORESDPFLACE_KEY=$91605,
      DBLNTSCEXTRALORESDPF2LACE_KEY=$91645,
      DBLPAL_MONITOR_ID=$A1000,
      DBLPALLORES_KEY=$A1000,
      DBLPALLORESFF_KEY=$A1004,
      DBLPALLORESHAM_KEY=$A1800,
      DBLPALLORESHAMFF_KEY=$A1804,
      DBLPALLORESEHB_KEY=$A1080,
      DBLPALLORESEHBFF_KEY=$A1084,
      DBLPALLORESLACE_KEY=$A1005,
      DBLPALLORESHAMLACE_KEY=$A1805,
      DBLPALLORESEHBLACE_KEY=$A1085,
      DBLPALLORESDPF_KEY=$A1400,
      DBLPALLORESDPFFF_KEY=$A1404,
      DBLPALLORESDPFLACE_KEY=$A1405,
      DBLPALLORESDPF2_KEY=$A1440,
      DBLPALLORESDPF2FF_KEY=$A1444,
      DBLPALLORESDPF2LACE_KEY=$A1445,
      DBLPALHIRES_KEY=$A9000,
      DBLPALHIRESFF_KEY=$A9004,
      DBLPALHIRESHAM_KEY=$A9800,
      DBLPALHIRESHAMFF_KEY=$A9804,
      DBLPALHIRESLACE_KEY=$A9005,
      DBLPALHIRESHAMLACE_KEY=$A9805,
      DBLPALHIRESEHB_KEY=$A9080,
      DBLPALHIRESEHBFF_KEY=$A9084,
      DBLPALHIRESEHBLACE_KEY=$A9085,
      DBLPALHIRESDPF_KEY=$A9400,
      DBLPALHIRESDPFFF_KEY=$A9404,
      DBLPALHIRESDPFLACE_KEY=$A9405,
      DBLPALHIRESDPF2_KEY=$A9440,
      DBLPALHIRESDPF2FF_KEY=$A9444,
      DBLPALHIRESDPF2LACE_KEY=$A9445,
      DBLPALEXTRALORES_KEY=$A1200,
      DBLPALEXTRALORESHAM_KEY=$A1A00,
      DBLPALEXTRALORESEHB_KEY=$A1280,
      DBLPALEXTRALORESDPF_KEY=$A1600,
      DBLPALEXTRALORESDPF2_KEY=$A1640,
      DBLPALEXTRALORESFF_KEY=$A1204,
      DBLPALEXTRALORESHAMFF_KEY=$A1A04,
      DBLPALEXTRALORESEHBFF_KEY=$A1284,
      DBLPALEXTRALORESDPFFF_KEY=$A1604,
      DBLPALEXTRALORESDPF2FF_KEY=$A1644,
      DBLPALEXTRALORESLACE_KEY=$A1205,
      DBLPALEXTRALORESHAMLACE_KEY=$A1A05,
      DBLPALEXTRALORESEHBLACE_KEY=$A1285,
      DBLPALEXTRALORESDPFLACE_KEY=$A1605,
      DBLPALEXTRALORESDPF2LACE_KEY=$A1645,
      MUST_FLAGS=$100E,
      SPECIAL_FLAGS=$100E,
      BIDTAG_DIPFMUSTHAVE=$80000001,
      BIDTAG_DIPFMUSTNOTHAVE=$80000002,
      BIDTAG_VIEWPORT=$80000003,
      BIDTAG_NOMINALWIDTH=$80000004,
      BIDTAG_NOMINALHEIGHT=$80000005,
      BIDTAG_DESIREDWIDTH=$80000006,
      BIDTAG_DESIREDHEIGHT=$80000007,
      BIDTAG_DEPTH=$80000008,
      BIDTAG_MONITORID=$80000009,
      BIDTAG_SOURCEID=$8000000A,
      BIDTAG_REDBITS=$8000000B,
      BIDTAG_BLUEBITS=$8000000C,
      BIDTAG_GREENBITS=$8000000D,
      BIDTAG_GFXPRIVATE=$8000000E
