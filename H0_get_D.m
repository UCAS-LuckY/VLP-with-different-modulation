function [D] = H0_get_D(H0, Pos_PD, Pos_LED, Oren_PD, Oren_LED, config)

Constant = (config.ml + 1)* config.detector_area / (2*pi);
vector_RxTx = Pos_LED - Pos_PD;
cos_sita = dot(vector_RxTx, Oren_LED)/(norm(vector_RxTx)*norm(Oren_LED));
cos_fai = dot(Oren_PD, vector_RxTx)/(norm(Oren_PD)*norm(vector_RxTx));
estimated_distance = sqrt(Constant/ H0 * cos_sita^(config.ml) *cos_fai);
D = estimated_distance;
end

