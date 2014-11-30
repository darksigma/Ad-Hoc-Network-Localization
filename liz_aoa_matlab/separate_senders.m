function [ csi_data_separate ] = separate_senders(log_data, sender)
% Separates the csi data from the log file for a given sender
    
    sender_count = 0;
    sender_csi = zeros(1,3,30,length(log_data));
    for i=1:length(log_data)
        send = log_data{1,i}.addr2;
        if isequal(send, sender)
            sender_count = sender_count + 1;
            csi = log_data{1,i}.csi;
            sender_csi(:,:,:,sender_count) = csi;
        end
    end
    csi_data_separate = sender_csi(:,:,:,(1:sender_count));
end

