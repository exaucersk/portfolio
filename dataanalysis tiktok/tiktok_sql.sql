Select*
From tiktokdata..tiktok_dataset$

Select video_id, video_view_count + video_like_count + video_share_count as Impressions, video_duration_sec
From tiktokdata..tiktok_dataset$

CREATE VIEW ImpressionsToLenght as
Select video_id, video_view_count + video_like_count + video_share_count as Impressions, video_duration_sec
From tiktokdata..tiktok_dataset$

Select*
From tiktokdata..ImpressionsToLenght