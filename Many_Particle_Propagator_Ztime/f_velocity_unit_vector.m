function e = f_velocity_unit_vector(v)
    e = v;
    
    for i = 1:length(v)
        normalization = norm(v(:, i));
        if v(:, i) == 0
            e(:, i) = [0, 0, 0];
        else
            e(:, i) = v(:,i) / normalization;
        end
    end
end

