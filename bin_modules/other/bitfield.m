EMOD        �P        
        NU   - "- �N]Nu    lshr             x,y ��  
NBITMASK      (Shl(1,())-1)   SETNBITSATX     <((() AND NOTNBITSATX(,)) OR Shl(() AND NBITMASK(), ))  GETNBITSATX     $(lshr(() AND NBITSATX(,), ()))   NOTNBITSATX     (Not(NBITSATX(,)))   
NBITSATX      (Shl(NBITMASK(),()))      