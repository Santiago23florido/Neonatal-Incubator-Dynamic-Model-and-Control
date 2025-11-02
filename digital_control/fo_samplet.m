function samples = fo_samplet(planta)
    G=planta;
    G2=tf(planta.Numerator{1},planta.Denominator{1});
    retardo=planta.InputDelay;
    Gc=feedback(G,1);
    G2c=feedback(G2,1);
    %sample_time
    %bandwith
    wc=bandwidth(Gc)
    ts1=[2*pi/(12*wc),2*pi/(8*wc)]
    G2c.Denominator
    teq=G2c.Denominator{1}(1)/G2c.Denominator{1}(2)
    ts2=[0.2*(teq+retardo),0.6*(teq+retardo)]
    tss=5*teq
    ts3=[0.05*(tss+retardo),0.15*(tss+retardo)]
    samples=[ts1;ts2;ts3];
end