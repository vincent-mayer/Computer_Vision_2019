function [K1,K2] = read_K(filepath)
%READ_K Summary of this function goes here
%   Detailed explanation goes here
str=fileread(filepath);
parts = regexp(str, '\[|\]', 'split');
K1 = double(str2num(parts{2}));
K2 = double(str2num(parts{4}));
end

