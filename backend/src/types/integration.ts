export interface WebhookPayload {
  event_type: string;
  timestamp: string; // ISO-8601 UTC
  data: any;
}

export interface DispatchRequest {
  target_url: string;
  payload: WebhookPayload;
  metadata?: A2P10DLC_Metadata;
}

export interface A2P10DLC_Metadata {
  recipient_phone: string; // strict US E.164 +1 NPA-NXX-XXXX
  opt_in_status: boolean;
  opt_in_timestamp: string;
  campaign_id?: string;
}

// Ensure phone numbers match strict US E.164 format
export const US_PHONE_REGEX = /^\+1[2-9]\d{2}[2-9]\d{6}$/;
