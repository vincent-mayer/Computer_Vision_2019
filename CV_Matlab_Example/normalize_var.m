 function m_scaled = normalize_var(m, x, y)

     % Normalize to [0, 1]:
     r_min = min(m,[],2);
     r_min = min(r_min);
     r_max = max(m,[],2);
     r_max = max(r_max);
     t_min = x;
     t_max = y;
     m_scaled = (t_max-t_min)*(m-r_min)/(r_max-r_min) + t_min;
 end