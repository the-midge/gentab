function [pitchs, pitchCandidates, harmonicTemplates, pitchScores]= mainPitch(x, fMin, fMax,pitchStep,tolerance,Fs,segments)
            %  [pitchs, pitchCandidates, harmonicTemplates, pitchScores]= mainPitch(self, fMin, fMax,pitchStep,tolerance)
            %  Computes dominant pitch trajectory between fMin and fMax.
            %  tolerance indicates in Hz the allowed variation of the main
            %  pitch from one frame to the next.
            % Returns:
            % * pitchs: a vector giving the detected pitch in Hz for each
            % frame.
            % * pitchCandidates: pitch frequencies used as candidates (Cx1
            %   vector)
            % * harmonicTemplates: template spectrum for each candidate
            %   (FxC) matrix
            % * pitchScores: matrix indicating the score for each candidate
            %   and each frame. (CxT) matrix
             N=2^11; h=190;   

            [stftRes, t, f]=stft(x, Fs, 2^11, h, N);
            
            pitchCandidates=fMin:pitchStep:fMax;
            harmonicTemplates=KLGLOTTModel(pitchCandidates,Fs).^2
            nPitchs = length(pitchCandidates);
            filterWidth = round(tolerance/pitchStep);
            pitchScores = zeros(nPitchs, size(segments,1));
            prevScore= misc.normalize(ones(nPitchs,1));
            for n = 1:size(segments,1)
                if rem(n,round(size(segments,1)/10)) == 1
                    disp(sprintf('pitch detection: %d%%',round(n/size(segments,1)*100)));
                    drawnow;
                end
                likelihoods = misc.normalize(exp(harmonicTemplates'*(abs(stftRes(:,n,1)).^2)));
                pitchScores(:,n) = misc.normalize(misc.normalize(misc.smooth(prevScore,filterWidth)).*likelihoods);
                prevScore = pitchScores(:,n);
            end
            [~, argPitch] = max(pitchScores,[],1);
            pitchs = pitchCandidates(argPitch);
        end
