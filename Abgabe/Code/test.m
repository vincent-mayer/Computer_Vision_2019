classdef test < matlab.unittest.TestCase
    %Test your challenge solution here using matlab unit tests
    %
    % Check if your main file 'challenge.m', 'disparity_map.m' and 
    % verify_dmap.m do not use any toolboxes.
    %
    % Check if all your required variables are set after executing 
    % the file 'challenge.m'
    
 

    properties
    end
    methods (Test)
	addpath('/lib/');
        function test_toolboxes(testCase)
            testCase.verifyFalse(check_toolboxes('challenge.m'));
            testCase.verifyFalse(check_toolboxes('disparity_map.m'));
            testCase.verifyFalse(check_toolboxes('verify_dmap.m'));
        end
        function test_variables(testCase)%,group_number, members, mail, elapsed_time, D,R,T,p)
            load('challenge.mat');
            testCase.verifyNotEmpty(members);
            testCase.verifyNotEmpty(mail);
            testCase.verifyEqual(group_number,59);
            testCase.verifyGreaterThan(elapsed_time,0);
            testCase.verifyGreaterThan(D,0);
            testCase.verifyGreaterThan(R,0);
            testCase.verifyGreaterThan(T,0);
            testCase.verifyGreaterThan(p,0);            
        %%Tests the PSNR of our function to the one of Image Processing Toolbox
        %check if the results are within a certain tolerance. (D,G tolerance
        %are to be specified.
            p_ours=verify_dmap(D,G);
            peaksnr=psnr(D,G);
            testCase.verifyEqual(p_ours,peaksnr,'AbsTol',e^-6);
        end
    end
end