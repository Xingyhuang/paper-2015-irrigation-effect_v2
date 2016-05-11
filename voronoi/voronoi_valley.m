function area = voronoi_valley()

cvs = load('cv_station_Tx_v3.txt');
cvb = load('cv_boundary.txt');

n = 1000;

% Boundary for the central valley
cvb_left = min(cvb(:,1));
cvb_bott = min(cvb(:,2));

cvb_right = max(cvb(:,1));
cvb_top   = max(cvb(:,2));

cvb(:,1) = (cvb(:,1) - cvb_left) / (cvb_right - cvb_left) * n;
cvb(:,2) = (cvb(:,2) - cvb_bott) / (cvb_top - cvb_bott) * n;

cvs(:,1) = (cvs(:,1) - cvb_left) / (cvb_right - cvb_left) * n;
cvs(:,2) = (cvs(:,2) - cvb_bott) / (cvb_top - cvb_bott) * n;

cvs = [cvs; -1000 -1000; -1000 2000; 2000 2000; 2000 -1000];

[v,c] = voronoin(cvs);

voronoi(cvs(:,1),cvs(:,2));
hold on;
plot(cvb(:,1), cvb(:,2), 'k-');

% Build the mask
valleymask = poly2mask(cvb(:,1), cvb(:,2), n, n);
area = zeros(size(c,1)-4,1);
for i = 1:size(c,1)-4

    cs = c{i};
    for j = 1:length(cs)
        if (cs(j) == 1)
            cs(j:length(cs)-1) = cs(j+1:length(cs));
            break;
        end
    end
    cvs = [];
    cvs(:,1) = v(cs',1);
    cvs(:,2) = v(cs',2);
    fill(cvs(:,1), cvs(:,2), 'r-');
    
    stationmask = poly2mask(cvs(:,1), cvs(:,2), n, n);
    area(i) = sum(sum(valleymask & stationmask));
end
hold off;

area = area / sum(area);

disp(sprintf('Total area: %1.5e', sum(area)));
disp(sprintf('Valley area: %1.5e', sum(sum(valleymask))));