  OPT MODULE
  OPT EXPORT

  OPT PREPROCESS

-> These need 'graphics/gfx', 'hardware/custom', 'hardware/dmabits'
#define ON_DISPLAY PutInt(CUSTOMADDR+DMACON,BITSET OR DMAF_RASTER)
#define OFF_DISPLAY PutInt(CUSTOMADDR+DMACON,BITCLR OR DMAF_RASTER)
#define ON_SPRITE PutInt(CUSTOMADDR+DMACON,BITSET OR DMAF_SPRITE)
#define OFF_SPRITE PutInt(CUSTOMADDR+DMACON,BITCLR OR DMAF_SPRITE)

-> Same, but 'hardware/intbits' instead of 'hardware/dmabits'
#define ON_VBLANK PutInt(CUSTOMADDR+INTENA,BITSET OR INTF_VERTB)
#define OFF_VBLANK PutInt(CUSTOMADDR+INTENA,BITCLR OR INTF_VERTB)

#define SetDrPt(w,p)   (PutInt((w)+RP_LINEPTRN,(p)) BUT \
                       PutInt((w)+RP_FLAGS,Int((w)+RP_FLAGS) OR FRST_DOT) BUT \
                       PutChar((w)+RP_LINPATCNT,15))
#define SetAfPt(w,p,n) (PutLong((w)+RP_AREAPTRN,(p)) BUT \
                       PutChar((w)+RP_AREAPTSZ,(n)))

#define SetOPen(w,c)   (PutChar((w)+RP_AOLPEN,(c)) BUT \
                       PutInt((w)+RP_FLAGS,Int((w)+RP_FLAGS) OR RPF_AREAOUTLINE))
#define SetWrMsk(w,m)  PutChar((w)+RP_MASK,(m))

#define SafeSetOutlinePen(w,c) (IF KickVersion(39) THEN SetOutlinePen((w),(c)) \
                               ELSE SetOPen(w,c))
#define SafeSetWriteMask(w,m)  (IF KickVersion(39) THEN SetWriteMask((w),(m)) \
                               ELSE SetWrMsk(w,m))

#define GetOutlinePen(rp) GetOPen((rp))

#define BNDRYOFF(w)  PutInt((w)+RP_FLAGS,Int((w)+RP_FLAGS) AND Not(RPF_AREAOUTLINE))

#define CINIT(c,n)     UcopperListInit((c),(n))
#define CMOVE(c,a,b)   (Cmove((c),{a},(b)) BUT Cbump((c)))
-> CMOVE is a little hard to use due to {a}.  CMOVEA() is the same except it
-> expects the address, so it may be easier to use...
#define CMOVEA(c,d,b)  (Cmove((c),(d),(b)) BUT Cbump((c)))
#define CWAIT(c,a,b)   (Cwait((c),(a),(b)) BUT Cbump((c)))
#define CEND(c)        CWAIT((c),10000,255)

#define DrawCircle(rp,cx,cy,r)  DrawEllipse((rp),(cx),(cy),(r),(r))
#define AreaCircle(rp,cx,cy,r)  AreaEllipse((rp),(cx),(cy),(r),(r))
