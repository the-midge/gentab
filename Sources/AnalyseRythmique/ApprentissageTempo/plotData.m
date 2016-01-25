function plotData(X, y)
%PLOTDATA Plots the data points X and y into a new figure 
%   PLOTDATA(x,y) plots the data points with + for the positive examples
%   and o for the negative examples. X is assumed to be a Mx2 matrix.

% Create New Figure
figure; hold on;
% ====================== YOUR CODE HERE ======================
% Instructions: Plot the positive and negative examples on a
%               2D plot, using the option 'k+' for the positive
%               examples and 'ko' for the negative examples.
%
positiveExamples = find(y==1);
negativeExamples = find(y==0);
if(size(X,2)==2)
    scatter(X(positiveExamples,1), X(positiveExamples,2), 'k+');
    hold on
    scatter(X(negativeExamples,1), X(negativeExamples,2), 'ko', 'MarkerFaceColor', 'y');
elseif size(X, 2)==3
    scatter3(X(positiveExamples,1), X(positiveExamples,2), X(positiveExamples,3),  'k+');
    hold on
    scatter3(X(negativeExamples,1), X(negativeExamples,2), X(negativeExamples,3),'ko', 'MarkerFaceColor', 'y');
end
set(gcf, 'Color', [1 1 1]); grid on;
% =========================================================================



hold off;

end
