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
        function test_toolboxes(testCase)
            testCase.verifyFalse(check_toolboxes('challenge.m')); % check_toolboxes returns true if more than just standard matlab are used.
            testCase.verifyFalse(check_toolboxes('disparity_map.m')); % Tests will be considered failed, if not false
            testCase.verifyFalse(check_toolboxes('verify_dmap.m'));
        end
        function test_variables(testCase)%Loads the .mat file, which has been saved right before calling the test function.
            global group_number members mail R T elapsed_time D p;
            %load('challenge.mat');		 %Verify that the specified variables are not empty or that they are greater than 0
            testCase.verifyNotEmpty(members); 
            testCase.verifyNotEmpty(mail);
            testCase.verifyEqual(group_number,59);
            testCase.verifyGreaterThan(elapsed_time,0);
            testCase.verifyNotEmpty(D);
            testCase.verifyNotEmpty(R);
            testCase.verifyNotEmpty(T);
            testCase.verifyGreaterThan(p,0);            
		end
        %%Tests the PSNR of our function to the one of Image Processing Toolbox
        %check if the results are within a certain tolerance(10^-1). 
		function check_psnr(testCase)
			global D G ;
            %load ('challenge.mat');
            p_ours=verify_dmap(double(D),double(G));
            peaksnr=psnr(double(D),double(G),255);
            testCase.verifyEqual(p_ours,peaksnr,'AbsTol',10^-1); %
        end
    end
end