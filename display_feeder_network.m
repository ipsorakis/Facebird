function display_feeder_network(W,X,LOCATIONS)

total_locations = size(W,1);

try
    load('LOCATIONS_IMG_XY');
    % location_IDs, locations_XY;
catch ME
    ME.stack;
    error('Could not find coordinates file');
end
%
% try
%     imshow('wytham_map.jpg');
% catch ME
%     ME.stack;
%     error('Could not find wytham_map.jpg');
% end

%LOCATIONS.show_active_locations('LOCATIONS_IMG_XY');
imshow('wytham_map.jpg');

hold on

Wmax = max(max(W));
for i=1:total_locations-1
    for j=i+1:total_locations
        if W(i,j)~=0
            %identify locations
            loc_i_coordinate_index = get_loc_coordinate_index(LOCATIONS.get_location_by_index(i),location_IDs);
            loc_j_coordinate_index = get_loc_coordinate_index(LOCATIONS.get_location_by_index(j),location_IDs);
            
            %put a circle on locations
            %circle([locations_XY(loc_i_coordinate_index,1) locations_XY(loc_i_coordinate_index,2)],100,1000,'-');
            %circle([locations_XY(loc_j_coordinate_index,1) locations_XY(loc_j_coordinate_index,2)],100,1000,'-');
            
            %put stem on locations
            stem3(locations_XY(loc_i_coordinate_index,1),locations_XY(loc_i_coordinate_index,2),length(X(i)));
            stem3(locations_XY(loc_j_coordinate_index,1),locations_XY(loc_j_coordinate_index,2),length(X(j)));
            
            %draw a line between locations
            plot(locations_XY(loc_i_coordinate_index,1),locations_XY(loc_i_coordinate_index,2),'bo','LineWidth',2);
            plot(locations_XY(loc_j_coordinate_index,1),locations_XY(loc_j_coordinate_index,2),'bo','LineWidth',2);
            
            line('xdata',[locations_XY(loc_i_coordinate_index,1) locations_XY(loc_j_coordinate_index,1)],...
                'ydata',[locations_XY(loc_i_coordinate_index,2) locations_XY(loc_j_coordinate_index,2)],...
                'Color',[W(i,j)/Wmax 0 1-W(i,j)/Wmax],'LineWidth',2)
        end
    end
end

for i=1:total_locations
    if X(i)~=0
        try
            loc_i_coordinate_index = get_loc_coordinate_index(LOCATIONS.get_location_by_index(i),location_IDs);
            circle([locations_XY(loc_i_coordinate_index,1) locations_XY(loc_i_coordinate_index,2)],100,1000,'-');
        catch ME
            ME.stack;
        end
    end
end

hold off
end

function index = get_loc_coordinate_index(location,location_IDs)
index = -1;
for i=1:length(location_IDs)
    if strcmp(location_IDs{i},location.ID)
        index = i;
        return;
    end
end
end