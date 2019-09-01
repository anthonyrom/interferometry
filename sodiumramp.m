function sodiumramp = sodiumramp(min,max,res,nramp)
pps = gpib('ni',0,2);
fopen(pps);
v = min;
rampn = 0;
while rampn < nramp
   while v <= max
       fprintf(pps, sprintf('%s %f','VSET',v));
       v = v + res;
       pause(2);
   end
   v = min;
   rampn = rampn+1;
       
end
fclose(pps);
end