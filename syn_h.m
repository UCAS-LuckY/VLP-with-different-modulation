function [h_syn] = syn_h(Feature_CIR)

for i =1:length(Feature_CIR(:,1))
    h_syn(i,:) = circshift(Feature_CIR(i,:)',-find(Feature_CIR(i,:)~=0, 1 )+1);
end

end

